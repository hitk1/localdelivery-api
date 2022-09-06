defmodule DeliveryapiWeb.CustomerOnboardingController do
  use DeliveryapiWeb, :controller

  alias CustomerAddresses.Repo.CustomerAddress
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

  def create_address(conn, params) do
    with {:ok, %{id: id}, status_code} <- Deliveryapi.create_customer_address(params) do
      conn
      |> put_status(status_code)
      |> render("customer_address_created.json", address_id: id)
    end
  end

  def get_address(conn, params) do
    with {:ok, address} <- Deliveryapi.get_address(params) do
      conn
      |> put_status(:ok)
      |> render("customer_address.json", address: address)
    end
  end

  def assign(conn, params) do
    with {:ok, _} <- Deliveryapi.assign(params) do
      conn
      |> put_status(:ok)
      |> json(%{message: "assigned"})
    end
  end
end
