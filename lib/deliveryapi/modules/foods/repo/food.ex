defmodule Foods.Repo.Food do
  use Ecto.Schema

  alias Categories.Repo.Category
  alias Merchants.Repo.Merchant

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "foods" do
    field :name, :string
    field :description, :string
    field :value, :integer
    field :type, :string
    field :image, :string
    field :is_refrigerated, :boolean
    field :contain_gluten, :boolean
    field :is_active, :boolean
    field :is_allowed_sell, :boolean
    field :deleted_at, :utc_datetime

    belongs_to(:merchant, Merchant, foreign_key: :merchant_id)
    belongs_to(:category, Category, foreign_key: :category_id)

    timestamps(type: :utc_datetime)
  end
end
