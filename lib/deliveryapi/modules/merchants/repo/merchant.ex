defmodule Merchants.Repo.Merchant do
  use Ecto.Schema
  import Ecto.Changeset

  alias Foods.Repo.Food

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

    has_many(:foods, Food)

    timestamps(type: :utc_datetime)
  end

  def validate_onboarding_base_data(params) do
    schema = %{
      email: :string,
      cnpj: :string,
      name: :string,
      company_name: :string,
      ie: :string,
      im: :string,
      is_active: :boolean,
      is_email_verified: :boolean,
      is_ready: :boolean,
      phone_number: :string,
      responsible: :string,
      cpf_responsible: :string
    }

    formated_params =
      Map.merge(
        %{
          "is_active" => false,
          "is_email_verified" => false,
          "is_ready" => false
        },
        params
      )

    result =
      {%__MODULE__{}, schema}
      |> cast(formated_params, Map.keys(schema))
      |> validate_required([
        :cnpj,
        :name,
        :company_name,
        :ie,
        :phone_number,
        :responsible,
        :cpf_responsible
      ])
      |> validate_length(:email, max: 350)
      |> validate_length(:cnpj, is: 14)
      |> validate_length(:name, max: 255)
      |> validate_length(:company_name, max: 300)
      |> validate_length(:ie, max: 50)
      |> validate_length(:phone_number, max: 50)
      |> validate_length(:responsible, max: 255)
      |> validate_length(:cpf_responsible, is: 11)
      |> validate_format(:email, ~r/@/)
      |> validate_format(:cnpj, ~r/^[0-9]*$/)
      |> validate_format(:ie, ~r/^[0-9]*$/)
      |> validate_format(:im, ~r/^[0-9]*$/)
      |> validate_format(:phone_number, ~r/^[0-9]*$/)
      |> validate_format(:cpf_responsible, ~r/^[0-9]*$/)
      |> unique_constraint([:email])
      |> unique_constraint([:cnpj])

    {:ok, result}
  end
end
