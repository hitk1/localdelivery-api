defmodule Sessions.Services.RefreshCustomerToken do
  use Guardian, otp_app: :deliveryapi

  alias Customers.Repo.Customer
  alias Deliveryapi.{Error, Repo}
  alias Tokens.Services.GenerateRefreshToken

  def resource_from_claims(%{"sub" => customer_id}) do
    Repo.get(Customer, customer_id)
  end

  def subject_for_token(%Customer{id: id}, _claims), do: {:ok, id}

  def call(customer_id) do
    with %Customer{} = customer <- Repo.get_by(Customer, id: customer_id, is_active: true),
         {:ok, refresh_token} <-
           GenerateRefreshToken.call(%{
             "entity" => "customer",
             "entity_id" => customer_id
           }),
         {:ok, token, _claims} <-
           encode_and_sign(
             customer,
             %{role: "customer"}
           ) do
      %{
        token: token,
        refresh_token: refresh_token,
        role: "customer",
        customer: %{
          id: Map.get(customer, :id),
          email: Map.get(customer, :email),
          is_active: Map.get(customer, :is_active),
          name: Map.get(customer, :name)
        }
      }
    else
      nil -> {:error, Error.not_found("Customer not found")}
    end
  end
end
