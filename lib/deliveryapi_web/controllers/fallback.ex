defmodule DeliveryapiWeb.FallbackController do
  use DeliveryapiWeb, :controller

  alias DeliveryapiWeb.ErrorView

  def call(conn, {:error, error}) do
    IO.inspect(error)

    conn
    |> put_status(:bad_request)
    |> put_view(ErrorView)
    |> render("error.json", error: error)
  end
end
