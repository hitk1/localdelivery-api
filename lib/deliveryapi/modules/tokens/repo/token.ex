defmodule Tokens.Repo.Token do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @required_params [:entity, :entity_id, :token]

  schema "tokens" do
    field :entity, :string
    field :entity_id, :string
    field :token, :string

    timestamps(type: :utc_datetime)
  end

  def changeset(params) do
    result =
      %__MODULE__{}
      |> cast(params, @required_params)
      |> validate_required(@required_params)
      |> unique_constraint(@required_params)

    {:ok, result}
  end
end
