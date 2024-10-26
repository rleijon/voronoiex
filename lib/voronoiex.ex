
defmodule Voronoiex do
  use Application
  require Logger

  def start(_type, _args) do
    webserver = {Plug.Cowboy, plug: Voronoiex.Api, scheme: :http, options: [port: 4000]}
    Logger.info "Starting Voronoiex on port 4000"
    Supervisor.start_link([webserver], strategy: :one_for_one)
  end
end
