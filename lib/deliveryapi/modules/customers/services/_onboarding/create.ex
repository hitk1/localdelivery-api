defmodule Customers.Services.Onboarding.CreateBaseData do
  import Ecto.Query, only: [from: 2]

  alias Customers.Repo.Customer
  alias Deliveryapi.{Repo, Error}
  alias Deliveryapi.Core.Tools.DateFormatter

  def call(params) do
    case Customer.changeset(%{action: "create_base_data", params: params}) do
      {:ok, %Ecto.Changeset{valid?: true} = changeset} ->
        %{"email" => user_email} = params

        with %Customer{} = found_user <-
               Repo.get_by(Customer, email: user_email, is_active: false) do
          update_customer(params, Map.get(found_user, :id))
        else
          nil ->
            case Repo.insert(changeset) do
              {:ok, created_customer} -> {:ok, created_customer, :created}
              error -> deal_error(error)
            end
        end

      {:ok, changeset} ->
        {:error, changeset}
    end
  end

  defp deal_error({:error, %Ecto.Changeset{valid?: false, errors: validation_errors}} = error) do
    {key, _value} =
      validation_errors
      |> List.first(:error)

    verify_type_validation(key, error)
  end

  defp deal_error(error), do: error

  defp verify_type_validation(:email, _error), do: {:error, Error.duplicate_key_error("Email já cadastrado")}

  defp verify_type_validation(_any, error), do: {:error, error}

  defp update_customer(
         %{
           "name" => name,
           "email" => email,
           "phone_number" => phone_number
         },
         customer_id
       ) do
    update_query =
      from(c in Customer,
        where: c.id == ^customer_id,
        update: [
          set: [
            name: ^name,
            email: ^email,
            phone_number: ^phone_number,
            updated_at: ^DateFormatter.now()
          ]
        ]
      )

    case Repo.update_all(update_query, []) do
      {1, nil} -> {:ok, %{id: customer_id}, :ok}
      error -> {:error, "Error on update existing user"}
    end
  end
end
