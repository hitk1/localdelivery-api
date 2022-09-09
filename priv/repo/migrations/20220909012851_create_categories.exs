defmodule Deliveryapi.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :name, :string, null: false
      add :description, :string, size: 300
      add :image, :string, size: 800
      add :is_active, :boolean, default: true
      add :deleted_at, :utc_datetime

      timestamps(type: :timestamptz)
    end

    create unique_index(:categories, [:name])
  end
end
