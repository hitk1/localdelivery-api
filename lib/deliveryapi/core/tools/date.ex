defmodule Deliveryapi.Core.Tools.DateFormatter do
  def now do
    timezone = get_timezone()
    {:ok, now} = DateTime.now(timezone)
    now
  end

  defp get_timezone() do
    :deliveryapi
      |> Application.fetch_env!(__MODULE__)
      |> Keyword.get(:default_timezone)
  end
end
