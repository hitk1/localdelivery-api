defmodule Deliveryapi.Repo.Migrations.Customers do
  use Ecto.Migration

  def change do
    create table(:customers) do
      add :name, :string, null: false
      add :email, :string, null: false
      add :password_hash, :string
      add :phone_number, :string, null: false
      add :is_active, :boolean, default: false
      add :is_email_verified, :boolean, default: false

      timestamps(type: :timestamptz)
    end

    create unique_index(:customers, [:email])
  end
end
