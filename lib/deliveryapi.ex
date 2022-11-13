defmodule Deliveryapi do
  alias Customers.Services.Onboarding.CreateBaseData, as: CreateCustomerBaseData
  alias Customers.Services.Onboarding.GetBaseData, as: GetCustomerBaseData
  alias Customers.Services.Onboarding.CreateAddress, as: CreateCustomerAddress
  alias Customers.Services.Onboarding.GetAddress, as: GetCustomerAddress
  alias Customers.Services.Onboarding.AssignPassword

  alias Sessions.Services.Auth, as: Session
  alias Sessions.Services.RefreshToken
  alias Sessions.Services.Firebase, as: FirebaseToken

  alias Merchants.Services.Onboarding.CreateBaseData, as: CreateMerchantBaseData
  alias Merchants.Services.Onboarding.GetBaseData, as: GetMerchantBaseData
  alias Merchants.Services.Onboarding.CreateAddress, as: CreateMerchantAddress
  alias Merchants.Services.Onboarding.GetAddress, as: GetMerchantAddress
  alias Merchants.Services.Onboarding.AssignMerchantPassword

  # Customer onboarding
  defdelegate create_customer_base_data(params), to: CreateCustomerBaseData, as: :call
  defdelegate get_customer_base_data(params), to: GetCustomerBaseData, as: :call
  defdelegate create_customer_address(params), to: CreateCustomerAddress, as: :call
  defdelegate get_address(params), to: GetCustomerAddress, as: :call
  defdelegate assign(params), to: AssignPassword, as: :call

  # Sessions
  defdelegate customer_login(params), to: Session, as: :customer_login

  defdelegate merchant_login(params), to: Session, as: :merchant_login
  defdelegate refresh_token(params), to: RefreshToken, as: :refresh_token
  defdelegate generate_firebase_token(params), to: FirebaseToken, as: :sign

  # Merchants onboarding
  defdelegate create_merchants_base_data(params), to: CreateMerchantBaseData, as: :call
  defdelegate get_merchant_base_data(params), to: GetMerchantBaseData, as: :call
  defdelegate create_merchant_address(params), to: CreateMerchantAddress, as: :call
  defdelegate get_merchant_address(params), to: GetMerchantAddress, as: :call
  defdelegate assign_merchant_password(params), to: AssignMerchantPassword, as: :call
end
