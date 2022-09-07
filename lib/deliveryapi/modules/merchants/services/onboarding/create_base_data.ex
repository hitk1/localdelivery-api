defmodule Merchants.Services.CreateBaseData do
  import Ecto.Query, only: [from: 2]

  alias Deliveryapi.{Error, Repo}
  alias Merchants.Repo.Merchant
  alias Deliveryapi.Core.Tools.DateFormatter

  def call(params) do
    case Merchant.validate_onboarding_base_data(params) do
      {:ok, %Ecto.Changeset{valid?: true} = changeset} ->
        %{"cnpj" => cnpj} = params

        get_merchant_by_cnpj(cnpj)
        |> handle_onboarding_merchant(changeset, params)

      {:ok, invalid_changeset} ->
        {:error, invalid_changeset}
    end
  end

  defp get_merchant_by_cnpj(cnpj) do
    case Repo.get_by(Merchant, cnpj: cnpj) do
      %Merchant{} = merchant -> {:ok, merchant}
      nil -> nil
    end
  end

  # Create the data
  defp handle_onboarding_merchant(existing_merchant, changeset, _params)
       when is_nil(existing_merchant) do
    case Repo.insert(changeset) do
      {:ok, %Merchant{id: id}} -> {:ok, id, :created}
      error -> error
    end
  end

  # Update the data for existing merchants
  defp handle_onboarding_merchant({:ok, %Merchant{} = existing_merchant}, _changeset, params) do
    %{id: id, is_active: is_merchant_active} = existing_merchant

    case is_merchant_active do
      true ->
        {:error, Error.build(:alert, "Operation denied")}

      false ->
        update_merchant_onboarding_data(Map.merge(%{"id" => id}, params))
    end
  end

  defp update_merchant_onboarding_data(data) do
    query =
      from(
        merchant in Merchant,
        where: merchant.cnpj == ^Map.get(data, "cnpj"),
        update: [
          set: [
            email: ^Map.get(data, "email"),
            name: ^Map.get(data, "name"),
            company_name: ^Map.get(data, "company_name"),
            ie: ^Map.get(data, "ie"),
            im: ^Map.get(data, "im", ""),
            phone_number: ^Map.get(data, "phone_number"),
            responsible: ^Map.get(data, "responsible"),
            cpf_responsible: ^Map.get(data, "cpf_responsible"),
            updated_at: ^DateFormatter.now()
          ]
        ]
      )

    case Repo.update_all(query, []) do
      {1, nil} -> {:ok, Map.get(data, "id"), :ok}
      _error -> {:error, "Error ou update existing merchant"}
    end
  end
end
