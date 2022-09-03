defmodule Customers.Services.Onboarding.CreateAddress do
  import Ecto.Query, only: [from: 2]

  alias Cities.Repo.City
  alias Cities.Services.GetCityByIbgeCode
  alias CustomerAddresses.Repo.CustomerAddress
  alias Customers.Repo.Customer
  alias Deliveryapi.{Error, Repo}

  def call(params) do
    case CustomerAddress.validate_create_params(params) do
      {:ok, %Ecto.Changeset{valid?: true} = changeset} ->
        %{
          "address" => address,
          "number" => number,
          "neighborhood" => neighborhood,
          "complement" => complement,
          "zip_code" => zip_code,
          "ibge_code" => ibge_code,
          "customer_id" => received_customer_id,
          "address_alias" => address_alias
        } = params

        with {:ok, %City{id: city_id}} <- GetCityByIbgeCode.call(ibge_code),
             {:ok, %Customer{id: customer_id}} <- get_customer_by_id(received_customer_id) do
          create_params = %{
            "address" => address,
            "number" => number,
            "neighborhood" => neighborhood,
            "complement" => complement,
            "zip_code" => zip_code,
            "customer_id" => customer_id,
            "city_id" => city_id,
            "address_alias" => address_alias
          }

          case Repo.get_by(CustomerAddress, customer_id: customer_id, address_alias: address_alias) do
            %CustomerAddress{} = existing_address ->
              update_existing_address(create_params, Map.get(existing_address, :id))

            nil ->
              create_new_address(create_params)
              |> handle_create_address()
          end
        end

      {:ok, invalid_changeset} ->
        {:error, invalid_changeset}
    end
  end

  defp handle_create_address({:ok, address}), do: {:ok, address, :created}

  defp handle_create_address({:error, _error_changeset} = error_action), do: error_action

  defp create_new_address(params) do
    case CustomerAddress.entity_changeset(params) do
      {:ok, %Ecto.Changeset{valid?: true} = changeset} ->
        Repo.insert(changeset)

      {:ok, changeset} ->
        IO.puts("Error on create new address", label: "create address")
        {:error, changeset}
    end
  end

  defp update_existing_address(
         %{
           "address" => address,
           "number" => number,
           "neighborhood" => neighborhood,
           "complement" => complement,
           "zip_code" => zip_code,
           "city_id" => city_id
         },
         address_id
       ) do
    update_query =
      from(address in CustomerAddress,
        where: address.id == ^address_id,
        update: [
          set: [
            address: ^address,
            number: ^number,
            neighborhood: ^neighborhood,
            complement: ^complement,
            zip_code: ^zip_code,
            city_id: ^city_id
          ]
        ]
      )

    case Repo.update_all(update_query, []) do
      {1, nil} -> {:ok, %{id: address_id}, :ok}
      _ -> {:error, "Error on updating existing address"}
    end
  end

  defp get_customer_by_id(customer_id) do
    case Repo.get_by(Customer, id: customer_id, is_active: false, is_email_verified: false) do
      %Customer{} = customer -> {:ok, customer}
      nil -> {:error, Error.not_found("Customer not found")}
    end
  end
end
