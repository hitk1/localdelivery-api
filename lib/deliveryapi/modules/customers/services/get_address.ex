defmodule Customers.Services.Onboarding.GetAddress do
  import Ecto.Query, only: [from: 2]

  alias Deliveryapi.{Error, Repo}
  alias CustomerAddresses.Repo.CustomerAddress
  alias Cities.Repo.City

  def call(%{"address_id" => received_id}) do
    case Ecto.UUID.cast(received_id) do
      {:ok, address_id} ->
        get_address(address_id)

      :error ->
        {:error, Error.invalid_id("Invalid address id")}
    end
  end

  defp get_address(address_id) do
    query =
      from(
        address in CustomerAddress,
        join: city in City,
        on: address.city_id == city.id
      )

    query =
      from(
        [address, city] in query,
        where: address.id == ^address_id,
        select: {
          address.address,
          address.number,
          address.complement,
          address.neighborhood,
          address.address_alias,
          city.name,
          city.ibge_code,
          city.state_short_name
        }
      )

    Repo.one(query)
    |> handle_result()
  end

  defp handle_result(nil), do: {:error, Error.not_found("Address not found")}
  defp handle_result(address), do: {:ok, address}
end
