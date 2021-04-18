use Mix.Config

config :todo, :database, db_folder: "./db/dev"
config :todo, :server, idle_timeout: :timer.seconds(10)
