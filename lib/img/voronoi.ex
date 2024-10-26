defmodule Voronoiex.Img do
  def voronoi_ascii(symbols) do
    {min_x, min_y, max_x, max_y} = {0, 0, 100, 100}

    sites =
      Enum.map(1..length(symbols), fn _ ->
        {min_x + :rand.uniform(max_x - min_x), min_y + :rand.uniform(max_y - min_y)}
      end)

    sitemap =
      Enum.zip(symbols, sites)
      |> Map.new(fn {symbol, site} -> {site, symbol} end)

    pixels =
      min_x..max_x
      |> Enum.flat_map(fn x ->
        min_y..max_y
        |> Enum.map(fn y ->
          {x, y}
        end)
      end)

    pixelmap =
      Enum.reduce(pixels, %{}, fn {x, y}, acc ->
        closest =
          Enum.min_by(sites, fn {x1, y1} -> :math.pow(x1 - x, 2) + :math.pow(y1 - y, 2) end)

        Map.put(acc, {x, y}, sitemap[closest])
      end)

    for y <- min_y..max_y do
      for x <- min_x..max_x do
        IO.write(pixelmap[{x, y}])
      end

      IO.puts("")
    end
  end

  def voronoi_rgb(n, max_x \\ 500, max_y \\ 500, filename \\ "voronoi.jpg") do
    symbols =
      0..n
      |> Enum.map(fn _ ->
        [:rand.uniform(256) - 1, :rand.uniform(256) - 1, :rand.uniform(256) - 1]
      end)

    {min_x, min_y} = {0, 0}

    sites =
      Enum.map(1..length(symbols), fn _ ->
        {min_x + :rand.uniform(max_x - min_x), min_y + :rand.uniform(max_y - min_y)}
      end)

    sitemap =
      Enum.zip(symbols, sites)
      |> Map.new(fn {symbol, site} -> {site, symbol} end)

    pixels =
      min_x..max_x
      |> Enum.flat_map(fn x ->
        min_y..max_y
        |> Enum.map(fn y ->
          {x, y}
        end)
      end)

    pixelmap =
      Enum.reduce(pixels, %{}, fn {x, y}, acc ->
        closest =
          Enum.min_by(sites, fn {x1, y1} -> :math.pow(x1 - x, 2) + :math.pow(y1 - y, 2) end)

        Map.put(acc, {x, y}, sitemap[closest])
      end)

    pixeldata =
      min_y..max_y
      |> Enum.flat_map(fn y ->
        min_x..max_x
        |> Enum.flat_map(fn x ->
          pixelmap[{x, y}]
        end)
      end)

    {:ok, img} =
      Vix.Vips.Image.new_from_binary(
        :binary.list_to_bin(pixeldata),
        max_x - min_x + 1,
        max_y - min_y + 1,
        3,
        :VIPS_FORMAT_UCHAR
      )

    Vix.Vips.Image.write_to_file(img, filename)
  end
end
