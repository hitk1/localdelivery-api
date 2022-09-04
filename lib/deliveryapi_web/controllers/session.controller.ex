defmodule DeliveryapiWeb.SessionController do
  use DeliveryapiWeb, :controller

  alias DeliveryapiWeb.FallbackController

  action_fallback(FallbackController)

  def customer_session(conn, params) do
    with {:ok, result} <- Deliveryapi.customer_login(params) do
      conn
      |> put_status(:ok)
      |> render("customer_login.json", session: result)
    end
  end
end
