use Mix.Config

config :todo, http_port: 5454

import_config "#{Mix.env()}.exs"
