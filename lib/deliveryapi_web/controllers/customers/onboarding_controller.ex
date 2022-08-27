defmodule DeliveryapiWeb.CustomerOnboardingController do
  use DeliveryapiWeb, :controller

  alias Customers.Repo.Customer
  alias DeliveryapiWeb.FallbackController

  action_fallback(FallbackController)

  def create_base_data(conn, params) do
    with {:ok, %{id: id}, status_code} <- Deliveryapi.create_customer_base_data(params) do
      conn
      |> put_status(status_code)
      |> render("customer_base_data_created.json", user_id: id)
    end
  end

  def get_base_data(conn, params) do
    with {:ok, %Customer{} = customer} <- Deliveryapi.get_base_data(params) do
      conn
      |> put_status(:ok)
      |> render("customer_base_data.json", customer: customer)
    end
  end

  # def create_address(conn, params) do
  # end
end
