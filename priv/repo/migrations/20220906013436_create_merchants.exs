defmodule Deliveryapi.Repo.Migrations.CreateMerchants do
  use Ecto.Migration

  def change do
    create table(:merchants) do
      add :email, :string, null: false, size: 350
      add :password_hash, :string
      add :name, :string, null: false
      add :company_name, :string, null: false, size: 300
      add :cnpj, :string, null: false
      add :ie, :string, null: false, size: 50
      add :im, :string, size: 50
      add :phone_number, :string, size: 50
      add :is_active, :boolean, default: false
      add :is_email_verified, :boolean, default: false
      add :is_ready, :boolean, default: false
      add :responsible, :string, null: false
      add :cpf_responsible, :string, null: false, size: 50
      add :logo, :string, null: false, size: 800
      add :comission, :decimal, default: 0

      timestamps(type: :timestamptz)
    end

    create unique_index(:merchants, [:cnpj])
    create unique_index(:merchants, [:email])
  end
end
