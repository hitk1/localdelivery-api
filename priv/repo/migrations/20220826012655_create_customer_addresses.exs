defmodule Deliveryapi.Repo.Migrations.CreateCustomerAddresses do
  use Ecto.Migration

  def change do
    create table(:customer_addresses) do
      add :address, :string, null: false, size: 300
      add :number, :string
      add :neighborhood, :string, null: false
      add :complement, :string
      add :zip_code, :string, null: false, size: 8
      add :address_alias, :string, null: false

      add :customer_id, references(:customers, type: :binary_id)
      add :city_id, references(:cities, type: :binary_id)

      timestamps(type: :timestamptz)
    end

    create unique_index(:customer_addresses, [:customer_id, :address_alias])
  end
end
