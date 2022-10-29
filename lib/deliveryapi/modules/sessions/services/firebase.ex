defmodule Sessions.Services.Firebase do
  alias Deliveryapi.Error

  def sign(%{"merchant_id" => id}) do
    load_firebase_credentials()
    |> go_sign_token(id)
  end

  defp go_sign_token({:ok, credentials}, id) do
    %{
      "client_email" => client_email,
      "private_key" => private_key
    } = credentials

    key = JOSE.JWK.from_pem(private_key)

    signature = %{
      "alg" => "RS256"
    }

    now = DateTime.utc_now() |> DateTime.to_unix()
    next_exp = DateTime.utc_now() |> DateTime.add(3600, :second) |> DateTime.to_unix()

    payload = %{
      "iss" => client_email,
      "sub" => client_email,
      "aud" => "https://identitytoolkit.googleapis.com/google.identity.identitytoolkit.v1.IdentityToolkit",
      "iat" => now,
      "exp" => next_exp,
      "uid" => id
    }

      {_, token} =
      JOSE.JWT.sign(key, signature, payload)
      |> JOSE.JWS.compact()

    {:ok, token}
  end

  defp go_sign_token({:error, message}, _), do: {:error, Error.build(:internal_error, message)}

  defp load_firebase_credentials() do
    file_path = "firebase-admin.json"

    with {:ok, raw_file} <- File.read(file_path),
         {:ok, json} <- Poison.decode(raw_file) do
      {:ok, json}
    else
      _ -> {:error, "Unexpected error on read firebase credentials"}
    end
  end
end
