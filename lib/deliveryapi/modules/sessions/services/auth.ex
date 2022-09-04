defmodule Sessions.Services.Auth do
  use Guardian, otp_app: :deliveryapi

  alias Customers.Repo.Customer
  alias Deliveryapi.{Error, Repo}

  def subject_for_token(%Customer{id: id}, _claims), do: {:ok, id}

  def customer_login(params) do
    case Customer.validate_login(params) do
      {:ok, %Ecto.Changeset{valid?: true}} ->
        %{
          "email" => email,
          "password" => password
        } = params

        with {:ok, %Customer{} = customer} <- get_customer_by_email(email),
             true <- Pbkdf2.verify_pass(password, Map.get(customer, :password_hash)),
             # %{role: "customer"} -> additional data goes to jwt payload
             {:ok, token, _claims} <-
               encode_and_sign(
                 customer,
                 %{role: "customer"}
               ) do
          {:ok,
           %{
             token: token,
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

  defp get_customer_by_email(email) do
    case Repo.get_by(Customer, email: email, is_active: true) do
      %Customer{} = customer ->
        {:ok, customer}

      nil ->
        {:error, Error.not_found("Customer not found by email")}
    end
  end
end
