defmodule Merchants.Services.Onboarding.AssignMerchantPassword do
  import Ecto.Query, only: [from: 2]

  alias Deliveryapi.Core.Tools.DateFormatter
  alias Deliveryapi.{Error, Repo}
  alias Merchants.Repo.Merchant

  def call(params) do
    case Merchant.validate_assign_password(params) do
      {:ok, %Ecto.Changeset{valid?: true} = _} -> assign_password(params)
      {:ok, invalid_changeset} -> {:error, invalid_changeset}
    end
  end

  defp assign_password(params) do
    %{
      "merchant_id" => merchant_id,
      "password" => password,
      "repeat_password" => repeat_password
    } = params

    if password != repeat_password do
      {:error, Error.build("not_match", "password does not match each other")}
    else
      %{password_hash: password_hash} = Pbkdf2.add_hash(password)

      query =
        from(
          merchant in Merchant,
          where:
            merchant.id == ^merchant_id and
              merchant.is_active == ^false and
              merchant.is_email_verified == ^false and
              is_nil(merchant.password_hash),
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
        {1, nil} -> {:ok, message: "Password assigned successfully!"}
        _ -> {:error, "Merchant not found"}
      end
    end
  end
end
