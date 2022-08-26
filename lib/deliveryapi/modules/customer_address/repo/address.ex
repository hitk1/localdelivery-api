defmodule CustomerAddresses.Repo.CustomerAddress do
  use Ecto.Schema
  import Ecto.Changeset

  alias Customers.Repo.Customer
  alias Cities.Repo.City

  @primery_key {:id, :binary_id, autogenerate: true}

  schema "customer_addresses" do
    field :address, :string
    field :number, :string
    field :neighborhood, :string
    field :complement, :string
    field :zip_code, :string
    field :address_alias, :string

    belongs_to :customer, :Customer
    has_one :city, :City

    timestamps(type: :utc_datetime)
  end
end
