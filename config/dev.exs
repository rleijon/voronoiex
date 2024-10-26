# config/config.exs

config :voronoiex, YourAppWeb.Endpoint,
  # <---- ADD THIS LINE
  adapter: Bandit.PhoenixAdapter,
  url: [host: "localhost"]
