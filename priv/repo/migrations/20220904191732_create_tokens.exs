defmodule Deliveryapi.Repo.Migrations.CreateTokens do
  use Ecto.Migration

  def change do
    create table(:tokens) do
      add :entity, :string, null: false
      add :entity_id, :string, null: false
      add :token, :string, null: false

      timestamps(type: :timestamptz)
    end

    create unique_index(:tokens, [:entity, :entity_id, :token])
  end
end
