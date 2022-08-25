defmodule Deliveryapi do
  alias Customers.Services.Onboarding.CreateBaseData, as: CreateCustomerBaseData

  defdelegate create_customer_base_data(params), to: CreateCustomerBaseData, as: :call
end
