import Config

config :test_app, TestApp.Repo,
  database: "test_app_test",
  username: "postgres",
  password: "password",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
