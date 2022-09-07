defmodule Merchants.Services.Onboarding.GetBaseData do
  alias Ecto.UUID
  alias Deliveryapi.{Error, Repo}
  alias Merchants.Repo.Merchant

  def call(%{"merchant_id" => merchant_id}) do
    case UUID.cast(merchant_id) do
      {:ok, _} -> get_data(merchant_id)
      :error -> {:error, Error.validation_error("Invalid ID")}
    end
  end

  defp get_data(merchant_id) do
    case Repo.get_by(Merchant, id: merchant_id, is_active: false, is_email_verified: false) do
      nil -> {:error, Error.not_found("Merchant not found")}
      merchant -> {:ok, merchant}
    end
  end
end
