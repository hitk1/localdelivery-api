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

  def refresh_token(conn, params) do
    Deliveryapi.refresh_token(params)
    |> handle_token(conn)

    # with {:ok, result} <- Deliveryapi.refresh_token(params) do
    #   conn
    #   |> put_status(:ok)
    #   |> render("")
    # end
  end

  defp handle_token(%{"role" => "customer"} = result, conn) do
    conn
    |> put_status(:ok)
    |> render("customer_login.json", session: result)
  end

  # Implement the handle to merchants login
  # defp handle_token(%{"role" => ""})
end
