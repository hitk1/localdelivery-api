defmodule DeliveryapiWeb.Router do
  use DeliveryapiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Session scope
  scope "/api/session", DeliveryapiWeb do
    pipe_through :api

    post "/customers", SessionController, :customer_session
    post "/merchants", SessionController, :merchant_session
    put "/refresh_token", SessionController, :refresh_token
    put "/firebase/:merchant_id", SessionController, :firebase_token
  end

  # Customers onboarding
  scope "/api/customers/onboarding", DeliveryapiWeb do
    pipe_through :api

    post "/base_data", CustomerOnboardingController, :create_base_data

    get "/base_data/:customer_id",
        CustomerOnboardingController,
        :get_customer_base_data

    post "/address", CustomerOnboardingController, :create_address
    get "/address/:address_id", CustomerOnboardingController, :get_address

    post "/assign", CustomerOnboardingController, :assign
  end

  # Merchants onboarding
  scope "/api/merchants/onboarding", DeliveryapiWeb do
    pipe_through :api

    post "/base_data", MerchantOnboardingController, :create_base_data
    get "/base_data/:merchant_id", MerchantOnboardingController, :get_base_data
    post "/address", MerchantOnboardingController, :create_address
    get "/address/:address_id", MerchantOnboardingController, :get_address

    post "/assign", MerchantOnboardingController, :assign_password
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
