use Mix.Config

config :todo, port: 5454
config :todo, :database, pool_size: 3
config :todo, :server, idle_timeout: :timer.minutes(1)

import_config "#{Mix.env()}.exs"
