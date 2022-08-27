defmodule DeliveryapiWeb.FallbackController do
  use DeliveryapiWeb, :controller

  alias Deliveryapi.Error
  alias DeliveryapiWeb.ErrorView

  def call(conn, {:error, %Error{error_code: _error_code, error: error_message} = error}) do
    conn
    |> put_status(:bad_request)
    |> put_view(ErrorView)
    |> render("error.json", error: error)
  end
end
