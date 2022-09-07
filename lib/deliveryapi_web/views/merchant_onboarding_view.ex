defmodule DeliveryapiWeb.MerchantOnboardingView do
  use DeliveryapiWeb, :view

  def render("merchant_onboarding_base_data.json", %{merchant_id: merchant_id}) do
    %{
      message: "Merchant created successfully",
      merchant_id: merchant_id
    }
  end

  def render("merchant_base_data.json", %{merchant: merchant}) do
    %{
      merchant: %{
        name: Map.get(merchant, :name),
        company_name: Map.get(merchant, :company_name),
        email: Map.get(merchant, :email),
        cnpj: Map.get(merchant, :cnpj),
        ie: Map.get(merchant, :ie),
        im: Map.get(merchant, :im),
        phone_number: Map.get(merchant, :phone_number),
        responsible: Map.get(merchant, :responsible),
        cpf_responsible: Map.get(merchant, :cpf_responsible)
      }
    }
  end

  def render("create_merchant_address.json", %{address_id: address_id}) do
    %{
      message: "Address created successfully!",
      address_id: address_id
    }
  end

  def render("get_merchant_address.json", %{address: address}) do
    {
      address_id,
      address,
      number,
      complement,
      neighborhood,
      zip_code,
      city_id,
      city,
      ibge_code,
      state
    } = address

    %{
      address: %{
        id: address_id,
        address: address,
        number: number,
        complement: complement,
        neighborhood: neighborhood,
        zip_code: zip_code,
        city_id: city_id,
        city: city,
        ibge_code: ibge_code,
        state: state
      }
    }
  end
end
