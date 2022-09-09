defmodule Admins.Repo.Admin do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @required_params [:name, :email, :password]

  schema "admins" do
    field :name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps(type: :utc_datetime)
  end

  def create_changeset(params) do
    %__MODULE__{}
    |> cast(params, [:name, :email, :password])
    |> validate_required(@required_params)
    |> put_password()
  end

  defp put_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(
      changeset,
      Pbkdf2.add_hash(password)
    )
  end
end
