import Config

config :test_app,
  ecto_repos: [TestApp.Repo]

config :test_app, TestApp.Repo,
  database: "test_app_dev",
  username: "postgres",
  password: "password",
  hostname: "localhost"

import_config "#{config_env()}.exs"
