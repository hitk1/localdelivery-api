defmodule Customers.Repo.Customer do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @required_params [:name, :email, :password, :phone_number]

  schema "customers" do
    field :name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :phone_number, :string
    field :is_active, :boolean
    field :is_email_verified, :boolean

    timestamps(type: :utc_datetime)
  end

  # Changeset for data creation
  def changeset(%{action: "create_base_data", params: params}) do
    formated_params =
      Map.merge(
        %{
          "is_active" => false,
          "is_email_verified" => false
        },
        params
      )

    result =
      %__MODULE__{}
      |> cast(formated_params, [:name, :email, :phone_number, :is_active, :is_email_verified])
      |> validate_required([:name, :email, :phone_number])
      |> validate_length(:name, min: 5)
      |> validate_format(:email, ~r/@/)
      |> validate_format(:phone_number, ~r/\d/)
      |> validate_length(:phone_number, is: 11)
      |> unique_constraint([:email])

    {:ok, result}
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
