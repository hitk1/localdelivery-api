defmodule Customers.Services.Onboarding.CreateBaseData do
  alias Customers.Repo.Customer
  alias Deliveryapi.Repo

  def call(params) do
    with {:ok, %Ecto.Changeset{valid?: true} = changeset} <-
           Customer.changeset(%{action: "create_base_data", params: params}) do
      Repo.insert(changeset)
    else
      error -> deal_error(error)
    end
  end

  defp deal_error(error), do: {:error, error}
end
