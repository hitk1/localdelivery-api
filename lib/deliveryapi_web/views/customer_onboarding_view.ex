defmodule DeliveryapiWeb.CustomerOnboardingView do
  use DeliveryapiWeb, :view

  def render("customer_base_data_created.json", %{user_id: user_id}) do
    %{
      message: "User created successfully!",
      user_id: user_id
    }
  end

  def render("customer_base_data.json", %{customer: customer}), do: %{customer: customer}

  def render("customer_address_created.json", %{address_id: address_id}) do
    %{
      message: "Address created successfully!",
      address_id: address_id
    }
  end

  def render("customer_address.json", %{address: address}) do
    {
      address,
      number,
      complement,
      neighborhood,
      address_alias,
      city_name,
      ibge_code,
      state
    } = address

    %{
      address: %{
        address: address,
        number: number,
        complement: complement,
        neighborhood: neighborhood,
        address_alias: address_alias,
        city_name: city_name,
        ibge_code: ibge_code,
        state: state
      }
    }
  end
end
