defmodule Deliveryapi.Core.Tools.DateFormatter do
  def now do
    timezone =
      :deliveryapi
      |> Application.fetch_env!(__MODULE__)
      |> Keyword.get(:default_timezone)

    {:ok, now} = DateTime.now(timezone)
    now
  end
end
