defmodule Sessions.Services.Auth do

  alias DeliveryapiWeb.Guardian.AuthMiddleware

  alias Customers.Repo.Customer
  alias Merchants.Repo.Merchant
  alias Deliveryapi.{Error, Repo}
  alias Tokens.Services.GenerateRefreshToken

  def customer_login(params) do
    case Customer.validate_login(params) do
      {:ok, %Ecto.Changeset{valid?: true}} ->
        %{
          "email" => email,
          "password" => password
        } = params

        with {:ok, %Customer{} = customer} <- get_customer_by_email(email),
             true <- Pbkdf2.verify_pass(password, Map.get(customer, :password_hash)),
             {:ok, refresh_token} <-
               GenerateRefreshToken.call(%{
                 "entity" => "customer",
                 "entity_id" => Map.get(customer, :id)
               }),
             # %{role: "customer"} -> additional data goes to jwt payloa"d
             {:ok, token, _claims} <-
               AuthMiddleware.encode_and_sign(
                 customer,
                 %{role: "customer"}
               ) do
          {:ok,
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
           }}
        else
          false -> {:error, Error.build(:unauthorized, "Invalid credentials")}
          {:error, %{error_code: :not_found}} = error -> error
        end

      {:ok, invalid_params} ->
        {:error, invalid_params}
    end
  end

  def merchant_login(params) do
    case Merchant.validate_login(params) do
      {:ok, %Ecto.Changeset{valid?: true}} ->
        %{"email" => email, "password" => password} = params

        with {:ok, merchant} <- get_merchant(email),
        true <- Pbkdf2.verify_pass(password, Map.get(merchant, :password_hash)),
        {:ok, refresh_token} <- GenerateRefreshToken.call(%{"entity" => "merchant", "entity_id" => Map.get(merchant, :id)}),
        {:ok, token, _claims} <- AuthMiddleware.encode_and_sign(
          merchant,
          %{role: "merchant"}
        )
         do

          {:ok,
          %{
            token: token,
            refresh_token: refresh_token,
            merchant: %{
              id: Map.get(merchant, :id),
              email: Map.get(merchant, :email),
              name: Map.get(merchant, :name)
            }
          }
        }
      else
        false -> {:error, Error.build(:unauthorized, "Invalid credentials")}
        {:error, %{error_code: :not_found}} = error -> error
        end
    end

  end

  defp get_merchant(email) do
    case Repo.get_by(Merchant, email: email, is_active: true) do
      nil -> {:error, Error.not_found("Merchant not found by email")}
      %Merchant{} = merchant -> {:ok, merchant}
    end
  end

  defp get_customer_by_email(email) do
    case Repo.get_by(Customer, email: email, is_active: true) do
      %Customer{} = customer ->
        {:ok, customer}

      nil ->
        {:error, Error.not_found("Customer not found by email")}
    end
  end
end
