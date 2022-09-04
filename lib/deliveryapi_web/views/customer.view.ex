defmodule DeliveryapiWeb.SessionView do
  use DeliveryapiWeb, :view

  def render("customer_login.json", %{session: payload}) do
    %{token: token, role: role, customer: customer} = payload

    %{
      token: token,
      role: role,
      customer: %{
        id: Map.get(customer, :id),
        email: Map.get(customer, :email),
        is_active: Map.get(customer, :is_active),
        name: Map.get(customer, :name)
      }
    }
  end
end
