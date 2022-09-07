defmodule CustomerAddresses.Repo.CustomerAddress do
  use Ecto.Schema
  import Ecto.Changeset

  alias Customers.Repo.Customer
  alias Cities.Repo.City

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @params_create_required [
    :address,
    :number,
    :neighborhood,
    :zip_code,
    :address_alias,
    :customer_id,
    :ibge_code
  ]
  @entity_schema %{
    address: :string,
    number: :string,
    neighborhood: :string,
    complement: :string,
    zip_code: :string,
    address_alias: :string,
    customer_id: Ecto.UUID,
    city_id: Ecto.UUID
  }

  schema "customer_addresses" do
    field :address, :string
    field :number, :string
    field :neighborhood, :string
    field :complement, :string
    field :zip_code, :string
    field :address_alias, :string

    belongs_to(:customer, Customer, foreign_key: :customer_id)
    belongs_to(:city, City, foreign_key: :city_id)

    timestamps(type: :utc_datetime)
  end

  def validate_create_params(params) do
    schema_validator = %{
      address: :string,
      number: :string,
      neighborhood: :string,
      complement: :string,
      zip_code: :string,
      address_alias: :string,
      customer_id: Ecto.UUID,
      ibge_code: :string
    }

    result =
      {%__MODULE__{}, schema_validator}
      |> cast(params, Map.keys(schema_validator))
      |> validate_required(@params_create_required)
      |> validate_format(:ibge_code, ~r/^[0-9]*$/)
      |> validate_format(:zip_code, ~r/^[0-9]*$/)
      |> validate_length(:ibge_code, is: 7)
      |> validate_length(:zip_code, is: 8)

    # |> unique_constraint([:customer_id, :address_alias])

    {:ok, result}
  end

  def entity_changeset(params) do
    result =
      {
        %__MODULE__{},
        @entity_schema
      }
      |> cast(params, Map.keys(@entity_schema))
      |> foreign_key_constraint(:customer_id)
      |> foreign_key_constraint(:city_id)
      |> unique_constraint([:customer_id, :address_alias])

    {:ok, result}
  end
end
