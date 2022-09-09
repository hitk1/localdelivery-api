defmodule Merchants.Services.Onboarding.GetAddress do
  import Ecto.Query, only: [from: 2]

  alias Cities.Repo.City
  alias Ecto.UUID
  alias Deliveryapi.{Error, Repo}
  alias MerchantAddresses.Repo.MerchantAddress
  alias Merchants.Repo.Merchant

  def call(%{"address_id" => address_id}) do
    case UUID.cast(address_id) do
      {:ok, _id} -> get_data(address_id)
      :error -> {:error, Error.validation_error("Invalid ID")}
    end
  end

  defp get_data(address_id) do
    query =
      from(
        address in MerchantAddress,
        join: city in City,
        on: address.city_id == city.id,
        join: merchant in Merchant,
        on:
          address.merchant_id == merchant.id and merchant.is_active == false and
            merchant.is_email_verified == false,
        where: address.id == ^address_id,
        select: {
          address.id,
          address.address,
          address.number,
          address.complement,
          address.neighborhood,
          address.zip_code,
          city.id,
          city.name,
          city.ibge_code,
          city.state_short_name
        }
      )

    case Repo.one(query) do
      nil -> {:error, Error.not_found("address not found")}
      result -> {:ok, result}
    end
  end
end
