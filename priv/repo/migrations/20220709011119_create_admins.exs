defmodule Deliveryapi.Repo.Migrations.CreateAdmins do
  use Ecto.Migration

  def change do
    create table(:admins) do
      add :name, :string
      add :email, :string
      add :password_hash, :string

      timestamps(type: :timestamptz)
    end
  end
end
