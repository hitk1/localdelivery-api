defmodule Customers.Services.Onboarding.GetBaseData do
  alias Ecto.UUID
  alias Deliveryapi.{Error, Repo}
  alias Customers.Repo.Customer

  def call(%{"customer_id" => customer_id}) do
    case UUID.cast(customer_id) do
      :error -> {:error, Error.validation_error("Invalid ID")}
      {:ok, uuid} -> get_data(uuid)
    end
  end

  defp get_data(customer_id) do
    case Repo.get(Customer, customer_id) do
      nil -> {:error, Error.not_found("User not found")}
      customer -> {:ok, customer}
    end
  end
end
