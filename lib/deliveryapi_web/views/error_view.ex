defmodule DeliveryapiWeb.ErrorView do
  use DeliveryapiWeb, :view

  import Ecto.Changeset, only: [traverse_errors: 2]

  alias Ecto.Changeset
  alias Deliveryapi.Error

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  # def render("500.json", _assigns) do
  #   %{errors: %{detail: "Internal Server Error"}}
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end

  def render("error.json", %{error: %Changeset{} = changeset}) do
    %{
      error: "validation_error",
      message: translate_errors(changeset)
    }
  end

  def render("error.json", %{error: %Error{error_code: error_code, error: error_message}}) do
    %{
      error_code: error_code,
      error: error_message
    }
  end

  def render("error.json", %{error: error}) do
    %{
      message: error
    }
  end

  def render("error.json", error) do
    IO.inspect(error, label: "UNcatch error")

    %{
      message: "Unexpected error"
    }
  end

  defp translate_errors(changeset) do
    traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", translate_value(value))
      end)
    end)
  end

  defp translate_value({:parameterized, Ecto.Enum, _map}), do: ""
  defp translate_value(value), do: to_string(value)
end
