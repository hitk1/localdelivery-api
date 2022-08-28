defmodule Cities.Services.GetCityByIbgeCode do
  alias Cities.Repo.City
  alias Deliveryapi.{Repo, Error}

  def call(ibge_code) do
    case Repo.get_by(City, ibge_code: ibge_code) do
      %City{} = city -> {:ok, city}
      nil -> {:error, Error.not_found("City not found by ibge code")}
    end
  end
end
