defmodule Customers.Repo.Customer do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: false}
  @required_params [:name, :email, :password, :phone_number]

  schema "customers" do
    field :name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :phone_number, :string
    field :is_active, :boolean
    field :is_email_verified, :boolean

    timestamps()
  end

  # Changeset for data criation
  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_params ++ [:is_active, :onboarding_status, :is_email_verified])
    |> validate_required(@required_params)
    |> validate_format(:email, ~r/@/)
    |> validate_format(:phone_number, ~r/\d/)
    |> unique_constraint([:email])
    |> put_password_hash
  end

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(
      changeset,
      Pbkdf2.add_hash(password)
    )
  end

  defp put_password_hash(changeset), do: changeset
end
