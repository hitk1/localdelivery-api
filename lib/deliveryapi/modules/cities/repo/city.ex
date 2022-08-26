defmodule Cities.Repo.City do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "cities" do
    field :name, :string
    field :ibge_code, :string
    field :state, :string
    field :state_short_name, :string

    timestamps(type: :utc_datetime)
  end
end
