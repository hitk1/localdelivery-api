defmodule Deliveryapi.Repo.Migrations.Cities do
  use Ecto.Migration

  def change do
    create table(:cities) do
      add :name, :string
      add :ibge_code, :string
      add :state, :string
      add :state_short_name, :string

      timestamps()
    end
  end
end
