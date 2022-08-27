defmodule DeliveryapiWeb.CustomerOnboardingView do
  use DeliveryapiWeb, :view

  def render("customer_base_data_created.json", %{user_id: user_id}) do
    %{
      message: "User created successfully!",
      user_id: user_id
    }
  end

  def render("customer_base_data.json", %{customer: customer}), do: %{customer: customer}
end
