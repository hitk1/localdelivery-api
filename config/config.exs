# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :deliveryapi,
  ecto_repos: [Deliveryapi.Repo]

config :deliveryapi, Deliveryapi.Repo,
  migration_primary_key: [type: :binary_id],
  migration_foreign_key: [type: :binary_id]

# Timezone databases
config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

config :deliveryapi, Deliveryapi.Core.Tools.DateFormatter, default_timezone: "America/Sao_Paulo"

# Configures the guardian params
config :deliveryapi, DeliveryapiWeb.Guardian.AuthMiddleware,
  issuer: "deliveryapi",
  secret_key: "WX2DUV8XNNqT6DlaCt3X0RopHfDZc//mlObndcU47EzNQt9IVVuWEDXCBN+Csuum",
  ttl: {8, :hours}

config :deliveryapi,
  jwt_issuer: "deliveryapi",
  jwt_signature: "WX2DUV8XNNqT6DlaCt3X0RopHfDZc//mlObndcU47EzNQt9IVVuWEDXCBN+Csuum"

# Configures the endpoint
config :deliveryapi, DeliveryapiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "cUPjrhQ6Scv2kEmcgbgSNoKdmyM8S12wF3VzjyGZ6cprDmhR7S6K11s7Pj+7sDFf",
  render_errors: [view: DeliveryapiWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Deliveryapi.PubSub,
  live_view: [signing_salt: "U20UZL4L"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
