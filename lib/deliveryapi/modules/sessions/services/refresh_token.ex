defmodule Sessions.Services.RefreshToken do
  alias Sessions.Services.RefreshToken
  alias Tokens.Services.GenerateRefreshToken
  alias Deliveryapi.{Error, Repo}

  alias Tokens.Repo.Token
  alias Merchants.Repo.Merchant
  alias Customers.Repo.Customer
  alias Sessions.Services.RefreshCustomerToken
  alias DeliveryapiWeb.Guardian.AuthMiddleware

  @type merchant_success_payload :: %{
          refresh_token: String.t(),
          token: String.t(),
          merchant: %{
            id: String.t(),
            name: String.t()
          }
        }
  @type customer_success_payload :: %{
          customer: %{
            id: String.t(),
            email: String.t(),
            name: String.t(),
            is_active: boolean()
          },
          token: String.t(),
          refresh_token: String.t(),
          role: String.t()
        }
  @spec refresh_token(%{token: String.t()}) ::
          {:error, {:ok, Ecto.Changeset.t()}}
          | {:error, Deliveryapi.Error}
          | {:ok, merchant_success_payload}
          | {:ok, customer_success_payload}
  def refresh_token(params) do
    case Token.validate_refresh_token(params) do
      {:ok, %Ecto.Changeset{valid?: true}} ->
        %{"token" => received_token} = params

        Repo.get_by(Token, token: received_token)
        |> handle_recover_token()

      invalid_changeset ->
        {:error, invalid_changeset}
    end
  end

  defp handle_recover_token(result) when is_nil(result),
    do: {:error, Error.not_found("Refresh token not found")}

  defp handle_recover_token(%Token{} = result) do
    %{entity: entity} = result

    case entity do
      "customer" -> generate_customer_token(result)
      "merchant" -> generate_merchant_token(result)
    end
  end

  defp generate_customer_token(%Token{entity_id: customer_id}) do
    with %Customer{} = customer <- Repo.get_by(Customer, id: customer_id, is_active: true),
         {:ok, refresh_token} <-
           GenerateRefreshToken.call(%{"entity" => "customer", "entity_id" => customer_id}),
           {:ok, token, _claims} <- AuthMiddleware.encode_and_sign(customer, %{role: "customer"}) do
             %{
              token: token,
              refresh_token: refresh_token,
              role: "customer",
              customer: %{
                id: Map.get(customer, :id),
                name: Map.get(customer, :name),
                is_active: Map.get(customer, :is_active),
                email: Map.get(customer, :email)
              }
             }
            else
              nil -> {:error, Error.not_found("Customer not found")}
           end
  end

  defp generate_merchant_token(%Token{entity_id: merchant_id}) do
    with %Merchant{} = merchant <- Repo.get_by(Merchant, id: merchant_id, is_active: true),
         {:ok, refresh_token} <-
           GenerateRefreshToken.call(%{"entity" => "merchant", "entity_id" => merchant_id}),
         {:ok, token, _claims} <- AuthMiddleware.encode_and_sign(merchant, %{role: "merchant"}) do
      %{
        token: token,
        refresh_token: refresh_token,
        role: "merchant",
        merchant: %{
          id: Map.get(merchant, :id),
          name: Map.get(merchant, :name)
        }
      }
    else
      nil -> {:error, Error.not_found("Merchant not found")}
    end
  end
end
