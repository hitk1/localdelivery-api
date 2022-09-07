defmodule DeliveryapiWeb.MerchantOnboardingController do
  use DeliveryapiWeb, :controller

  alias DeliveryapiWeb.FallbackController

  action_fallback(FallbackController)

  def create_base_data(conn, params) do
    with {:ok, merchant_id, status_code} <- Deliveryapi.create_merchants_base_data(params) do
      conn
      |> put_status(status_code)
      |> render("merchant_onboarding_base_data.json", merchant_id: merchant_id)
    end
  end

  def get_base_data(conn, params) do
    with {:ok, result} <- Deliveryapi.get_merchant_base_data(params) do
      conn
      |> put_status(:ok)
      |> render("merchant_base_data.json", merchant: result)
    end
  end
end
