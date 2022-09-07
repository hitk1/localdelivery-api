defmodule Deliveryapi do
  alias Customers.Services.Onboarding.CreateBaseData, as: CreateCustomerBaseData
  alias Customers.Services.Onboarding.GetBaseData, as: GetCustomerBaseData
  alias Customers.Services.Onboarding.CreateAddress, as: CreateCustomerAddress
  alias Customers.Services.Onboarding.GetAddress, as: GetCustomerAddress
  alias Customers.Services.Onboarding.AssignPassword

  alias Sessions.Services.Auth, as: Session
  alias Sessions.Services.RefreshToken

  alias Merchants.Services.CreateBaseData, as: CreateMerchantBaseData
  alias Merchants.Services.GetBaseData, as: GetMerchantBaseData

  # Customer onboarding
  defdelegate create_customer_base_data(params), to: CreateCustomerBaseData, as: :call
  defdelegate get_customer_base_data(params), to: GetCustomerBaseData, as: :call
  defdelegate create_customer_address(params), to: CreateCustomerAddress, as: :call
  defdelegate get_address(params), to: GetCustomerAddress, as: :call
  defdelegate assign(params), to: AssignPassword, as: :call

  # Sessions
  defdelegate customer_login(params), to: Session, as: :customer_login
  defdelegate refresh_token(params), to: RefreshToken, as: :refresh_token

  # Merchants onboarding
  defdelegate create_merchants_base_data(params), to: CreateMerchantBaseData, as: :call
  defdelegate get_merchant_base_data(params), to: GetMerchantBaseData, as: :call
end
