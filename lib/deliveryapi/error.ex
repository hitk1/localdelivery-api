defmodule Deliveryapi.Error do
  @keys [:error_code, :error]
  @enforce_keys

  defstruct @keys

  def build(error_code, error) do
    %__MODULE__{
      error_code: error_code,
      error: error
    }
  end

  def validation_error(error), do: build(:validation_error, error)
  def not_found(error), do: build(:not_found, error)
  def invalid_id(error), do: build(:invalid_id, error)
end
