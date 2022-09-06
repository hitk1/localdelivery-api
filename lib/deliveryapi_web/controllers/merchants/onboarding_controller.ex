defmodule DeliveryapiWeb.MerchantOnboardingController do
  use DeliveryapiWeb, :controller

  def create_base_data(conn, params) do
    conn
    |> put_status(:ok)
    |> json(%{message: "ok"})
  end
end
