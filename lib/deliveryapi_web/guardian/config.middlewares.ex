defmodule DeliveryapiWeb.Guardian.AuthMiddleware do

  @moduledoc false
  use Guardian, otp_app: :deliveryapi

  alias Deliveryapi.Repo

  alias Customers.Repo.Customer
  alias Merchants.Repo.Merchant


  @doc """
  Subject for token for the customers
  """
  def subject_for_token(%Customer{id: id}, _claims), do: {:ok, id}

  @doc """
  Subject for token for the merchants
  """
  def subject_for_token(%Merchant{id: id}, _claims), do: {:ok, id}

  def subject_for_token(_, _), do: {:error, "Unexpected error to get subject for token"}

  def resource_from_claims(%{"sub" => user_id, "role" => "customer"}) do
    user = Repo.get!(Customer, user_id)
    {:ok, user}
  end

  def resource_from_claims(%{"sub" => user_id, "role" => "merchant"}) do
    user = Repo.get!(Merchant, user_id)
    {:ok, user}
  end

  def resource_from_claims(_claims), do: {:error, "Unexpected error on get resource for claims"}

end
