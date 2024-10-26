# config/config.exs

config :voronoiex, YourAppWeb.Endpoint,
  adapter: Bandit.PhoenixAdapter, # <---- ADD THIS LINE
  url: [host: "localhost"]
