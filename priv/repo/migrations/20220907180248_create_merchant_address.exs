defmodule Deliveryapi.Repo.Migrations.CreateMerchantAddress do
  use Ecto.Migration

  def change do
    create table(:merchant_addresses) do
      add :address, :string, null: false, size: 300
      add :number, :string
      add :neighborhood, :string, null: false
      add :complement, :string
      add :zip_code, :string, null: false, size: 8

      add :merchant_id, references(:merchants, type: :binary_id)
      add :city_id, references(:cities, type: :binary_id)

      timestamps(type: :timestamptz)
    end

    create unique_index(:merchant_addresses, [:merchant_id])
  end
end
