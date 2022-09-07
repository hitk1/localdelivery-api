defmodule Merchants.Services.Onboarding.CreateAddress do
  alias Cities.Repo.City
  alias Cities.Services.GetCityByIbgeCode
  alias Deliveryapi.{Error, Repo}
  alias Deliveryapi.Core.Tools.DateFormatter
  alias Merchants.Repo.Merchant
  alias MerchantAddresses.Repo.MerchantAddress

  def call(params) do
    case MerchantAddress.validate_create_address(params) do
      {:ok, %Ecto.Changeset{valid?: true}} ->
        %{
          "address" => address,
          "number" => number,
          "complement" => complement,
          "neighborhood" => neighborhood,
          "zip_code" => zip_code,
          "ibge_code" => ibge_code,
          "merchant_id" => merchant_id
        } = params

        with {:ok, %City{id: city_id}} <- GetCityByIbgeCode.call(ibge_code),
             {:ok, %Merchant{}} <- get_merchant_by_id(merchant_id) do
          on_conflict_action = [
            set: [
              address: address,
              number: number,
              complement: complement,
              zip_code: zip_code,
              city_id: city_id,
              updated_at: DateFormatter.now()
            ]
          ]

          case(
            Repo.insert(
              %MerchantAddress{
                address: address,
                number: number,
                complement: complement,
                neighborhood: neighborhood,
                zip_code: zip_code,
                city_id: city_id,
                merchant_id: merchant_id
              },
              on_conflict: on_conflict_action,
              conflict_target: :merchant_id,
              returning: [:id]
            )
          ) do
            {:ok, %MerchantAddress{id: address_id}} ->
              {:ok, address_id, :ok}

            _ ->
              {:error,
               Error.build(:unexpected, "Unexpected error on upsert merchant address data")}
          end
        end

      {:ok, invalid_changeset} ->
        {:error, invalid_changeset}
    end
  end

  defp get_merchant_by_id(merchant_id) do
    case Repo.get_by(Merchant, id: merchant_id, is_active: false, is_email_verified: false) do
      %Merchant{} = merchant -> {:ok, merchant}
      nil -> {:error, Error.not_found("Merchant not found")}
    end
  end
end
