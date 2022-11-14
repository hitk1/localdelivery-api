defmodule Tokens.Services.GenerateRefreshToken do
  import Ecto.Query, only: [from: 2]
  alias Ecto.UUID
  alias Deliveryapi.Core.Tools.DateFormatter
  alias Deliveryapi.{Error, Repo}
  alias Tokens.Repo.Token

  def call(%{
        "entity" => "customer",
        "entity_id" => customer_id
      }) do
    case Repo.get_by(
           Token,
           entity: "customer",
           entity_id: customer_id
         ) do
      %Token{} = token -> update_existing_token(Map.get(token, :id))
      nil -> create_refresh_token(%{"entity" => "customer", "entity_id" => customer_id})
    end
  end

  def call(
        %{
          "entity" => "merchant",
          "entity_id" => merchant_id
        } = params
      ) do
    case Repo.get_by(
           Token,
           entity: "merchant",
           entity_id: merchant_id
         ) do

      %Token{} = token -> update_existing_token(Map.get(token, :id))
      nil -> create_refresh_token(params)
    end
  end

  defp update_existing_token(token_id) do
    new_token = UUID.generate()

    query =
      from(
        token in Token,
        where: token.id == ^token_id,
        update: [
          set: [
            token: ^new_token,
            updated_at: ^DateFormatter.now()
          ]
        ]
      )

    case Repo.update_all(query, []) do
      {1, nil} -> {:ok, new_token}
      _ -> {:error, Error.build(:unexpected_error, "Error on update refresh token")}
    end
  end

  defp create_refresh_token(%{"entity" => entity, "entity_id" => entity_id}) do
    token = UUID.generate()

    case Token.changeset(%{"entity" => entity, "entity_id" => entity_id, "token" => token}) do
      {:ok, %Ecto.Changeset{valid?: true} = changeset} ->
        case Repo.insert(changeset) do
          {:ok, _} ->
            {:ok, token}

          {:error, _changeset} ->
            {:error, Error.build(:unexpected_error, "error on create refresh token")}
        end

      {:ok, invalid_changeset} ->
        {:error, invalid_changeset}
    end
  end

  def call(_), do: {:error, Error.build(:unexpected_error, "Invalid parameters")}
end
