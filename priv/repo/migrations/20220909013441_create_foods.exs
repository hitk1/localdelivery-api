defmodule Deliveryapi.Repo.Migrations.CreateFoods do
  use Ecto.Migration

  def change do
    create table(:foods) do
      add :name, :string, null: false
      add :description, :string, size: 300
      add :value, :integer, null: false
      add :type, :string, null: false
      add :image, :string, size: 800
      add :is_refrigerated, :boolean, default: false
      add :contain_gluten, :boolean, default: false
      add :is_active, :boolean, default: false
      add :is_allowed_sell, :boolean, default: false
      add :deleted_at, :utc_datetime

      add :merchant_id, references(:merchants, type: :binary_id)
      add :category_id, references(:categories, type: :binary_id)

      timestamps(type: :timestamptz)
    end
  end
end
