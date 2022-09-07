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
end
