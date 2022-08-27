defmodule CustomerAddresses.Repo.CustomerAddress do
  use Ecto.Schema
  import Ecto.Changeset

  alias Customers.Repo.Customer
  alias Cities.Repo.City

  @primery_key {:id, :binary_id, autogenerate: true}
  @params_create_required [
    :address,
    :number,
    :neighborhood,
    :zip_code,
    :address_alias,
    :customer_id,
    :ibge_code
  ]

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

  def create_address(%{action: "create_address", params: params}) do
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

    model = %__MODULE__{}

    result =
      {model, schema_validator}
      |> cast(params, Map.keys(schema_validator))
      |> validate_required(@params_create_required)
      |> validate_format(:ibge_code, ~r/\d/)
      |> validate_format(:zip_code, ~r/\d/)
      |> validate_length(:ibge_code, is: 7)
      |> validate_length(:zip_code, is: 8)
      |> unique_constraint([:customer_id, :address_alias])

    {:ok, result}
  end
end
