defmodule Customers.Services.Onboarding.CreateAddress do
  alias CustomerAddresses.Repo.CustomerAddress

  def call(params) do
    case CustomerAddress.create_address(%{action: "create_address", params: params}) do
      {:ok, %Ecto.Changeset{valid?: true} = changeset} ->
        %{"ibge_code" => ibge_code} = params
        # write a function that get the city by the ibge code
        with {:ok, %City{id: id}} <- GetCityByIbgeCode.call(ibge_code)

      {:ok, invalid_changeset} ->
        {:error, invalid_changeset}
    end
  end
end
