defmodule Voronoiex.Api do
  use Plug.Router

  require Logger
  plug(:match)
  plug(:dispatch)

  get "/" do
    query_params = fetch_query_params(conn)
    n = query_params.params["n"] || "10"
    max_x = query_params.params["width"] || "500"
    max_y = query_params.params["height"] || "500"

    Voronoiex.Img.voronoi_rgb(
      String.to_integer(n),
      String.to_integer(max_x),
      String.to_integer(max_y)
    )

    conn
    |> put_resp_content_type("image/jpeg")
    |> send_file(200, "voronoi.jpg")
  end

  match _ do
    send_resp(conn, 404, "oops")
  end
end
