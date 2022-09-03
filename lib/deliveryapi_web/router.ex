defmodule DeliveryapiWeb.Router do
  use DeliveryapiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", DeliveryapiWeb do
    pipe_through :api

    # user onboarding
    post "/customers/onboarding/base_data", CustomerOnboardingController, :create_base_data

    get "/customers/onboarding/base_data/:customer_id",
        CustomerOnboardingController,
        :get_base_data

    post "/customers/onboarding/address", CustomerOnboardingController, :create_address
    get "/customers/onboarding/address/:address_id", CustomerOnboardingController, :get_address

    # post "/customers/onboarding/address", CustomerOnboardingController, :create_address
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: DeliveryapiWeb.Telemetry
    end
  end
end
