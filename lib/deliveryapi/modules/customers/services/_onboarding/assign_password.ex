defmodule Customers.Services.Onboarding.AssignPassword do
  import Ecto.Query, only: [from: 2]

  alias Deliveryapi.{Error, Repo}
  alias Customers.Repo.Customer
  alias Deliveryapi.Core.Tools.DateFormatter

  def call(params) do
    case Customer.validate_assign_password(params) do
      {:ok, %Ecto.Changeset{valid?: true}} -> assign_password(params)
      {:ok, invalid_changeset} -> {:error, invalid_changeset}
    end
  end

  defp assign_password(params) do
    %{
      "password" => password,
      "repeat_password" => repeat_password,
      "customer_id" => customer_id
    } = params

    if password != repeat_password do
      {:error, Error.build("not_match", "password does not match each other")}
    else
      %{password_hash: password_hash} = Pbkdf2.add_hash(password)

      query =
        from(
          customer in Customer,
          where:
            customer.id == ^customer_id and
              customer.is_active == ^false and
              customer.is_email_verified == ^false and
              is_nil(customer.password_hash),
          update: [
            set: [
              password_hash: ^password_hash,
              is_active: ^true,
              is_email_verified: ^true,
              updated_at: ^DateFormatter.now()
            ]
          ]
        )

      case Repo.update_all(query, []) do
        {1, nil} -> {:ok, message: "password assigned successfully!"}
        _ -> {:error, "Customer not found"}
      end
    end
  end
end
