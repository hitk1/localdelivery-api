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

  def merchant_session(conn, params) do
    with {:ok, result} <- Deliveryapi.merchant_login(params) do
      conn
      |> put_status(:ok)
      |> render("merchant_login.json", session: result)
    end
  end

  def refresh_token(conn, params) do
    with %{role: _any} = result <- Deliveryapi.refresh_token(params) do
      handle_token(result, conn)
    end
  end

  defp handle_token(%{role: "customer"} = result, conn) do
    conn
    |> put_status(:ok)
    |> render("customer_login.json", session: result)
  end

  # Implement the handle to merchants login
  defp handle_token(%{role: "merchant"} = result, conn) do
    conn
    |> put_status(:ok)
    |> render("merchant_login.json", session: result)
  end

  def firebase_token(conn, params) do
    with {:ok, firebase_token} <- Deliveryapi.generate_firebase_token(params) do
      conn
      |> put_status(:ok)
      |> render("firebase_token.json", token: firebase_token)
    end
  end
end
