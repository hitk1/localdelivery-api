defmodule Deliveryapi do
  alias Customers.Services.Onboarding.CreateBaseData, as: CreateCustomerBaseData
  alias Customers.Services.Onboarding.GetBaseData, as: GetCustomerBaseData
  alias Customers.Services.Onboarding.CreateAddress, as: CreateCustomerAddress
  alias Customers.Services.Onboarding.GetAddress, as: GetCustomerAddress
  alias Customers.Services.Onboarding.AssignPassword

  alias Sessions.Services.Auth, as: Session

  defdelegate create_customer_base_data(params), to: CreateCustomerBaseData, as: :call
  defdelegate get_base_data(params), to: GetCustomerBaseData, as: :call
  defdelegate create_customer_address(params), to: CreateCustomerAddress, as: :call
  defdelegate get_address(params), to: GetCustomerAddress, as: :call
  defdelegate assign(params), to: AssignPassword, as: :call

  # Sessions
  defdelegate customer_login(params), to: Session, as: :customer_login
end
