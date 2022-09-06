defmodule Sessions.Services.RefreshToken do
  alias Deliveryapi.{Error, Repo}
  alias Tokens.Repo.Token
  alias Sessions.Services.RefreshCustomerToken

  def refresh_token(params) do
    case Token.validate_refresh_token(params) do
      {:ok, %Ecto.Changeset{valid?: true}} ->
        %{"token" => received_token} = params

        Repo.get_by(Token, token: received_token)
        |> handle_recover_token()

      invalid_changeset ->
        {:error, invalid_changeset}
    end
  end

  defp handle_recover_token(result) when is_nil(result),
    do: {:error, Error.not_found("Refresh token not found")}

  defp handle_recover_token(%Token{} = result) do
    entity = Map.get(result, :entity)

    case entity do
      "customer" -> generate_customer_token(result)
      "merchant" -> {:error, Error.build("Not implemented yet")}
    end
  end

  defp generate_customer_token(%Token{} = customer_token) do
    RefreshCustomerToken.call(Map.get(customer_token, :entity_id))
  end
end
