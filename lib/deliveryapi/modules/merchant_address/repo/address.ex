defmodule MerchantAddresses.Repo.MerchantAddress do
  use Ecto.Schema
  import Ecto.Changeset

  alias Cities.Repo.City
  alias Merchants.Repo.Merchant

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "merchant_addresses" do
    field :address, :string
    field :number, :string
    field :neighborhood, :string
    field :complement, :string
    field :zip_code, :string

    belongs_to(:merchant, Merchant, foreign_key: :merchant_id)
    belongs_to(:city, City, foreign_key: :city_id)

    timestamps(type: :utc_datetime)
  end

  def validate_create_address(params) do
    schema = %{
      address: :string,
      number: :string,
      complement: :string,
      neighborhood: :string,
      ibge_code: :string,
      zip_code: :string,
      merchant_id: Ecto.UUID
    }

    result =
      {%__MODULE__{}, schema}
      |> cast(params, Map.keys(schema))
      |> validate_required([:address, :number, :neighborhood, :ibge_code, :zip_code, :merchant_id])
      |> validate_length(:address, max: 300)
      |> validate_length(:number, max: 255)
      |> validate_length(:neighborhood, max: 255)
      |> validate_length(:complement, max: 255)
      |> validate_length(:zip_code, is: 8)
      |> validate_length(:ibge_code, is: 7)
      |> validate_format(:ibge_code, ~r/^[0-9]*$/)
      |> validate_format(:zip_code, ~r/^[0-9]*$/)

    {:ok, result}
  end
end
