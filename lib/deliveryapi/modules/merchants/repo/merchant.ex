defmodule Merchants.Repo.Merchant do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "merchants" do
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :name, :string
    field :company_name, :string
    field :cnpj, :string
    field :ie, :string
    field :im, :string
    field :phone_number, :string
    field :is_active, :boolean
    field :is_email_verified, :boolean
    field :is_ready, :boolean
    field :responsible, :string
    field :cpf_responsible, :string
    field :logo, :string
    field :comission, :decimal

    timestamps(type: :utc_datetime)
  end
end
