defmodule Categories.Repo.Category do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "categories" do
    field :name, :string
    field :description, :string
    field :image, :string
    field :is_active, :boolean
    field :deleted_at, :utc_datetime

    timestamps(type: :utc_datetime)
  end

  def create_changeset(params) do
    result =
      %__MODULE__{}
      |> cast(params, [:name, :description, :image])
      |> validate_required([:name, :description])

    {:ok, result}
  end
end
