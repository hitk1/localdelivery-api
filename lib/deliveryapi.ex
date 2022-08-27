defmodule Deliveryapi do
  alias Customers.Services.Onboarding.CreateBaseData, as: CreateCustomerBaseData
  alias Customers.Services.Onboarding.GetBaseData, as: GetCustomerBaseData

  defdelegate create_customer_base_data(params), to: CreateCustomerBaseData, as: :call
  defdelegate get_base_data(params), to: GetCustomerBaseData, as: :call
end
