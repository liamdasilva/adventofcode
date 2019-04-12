defmodule Day17.Q1 do
  @moduledoc """
  Documentation for Day 17 Q1.
  """

  @water "~"
  @trickle "|"
  @sand "."
  @clay "#"

  def run(input_stream) do
    parse_input(input_stream)
    |> trickle_water({500, 0})
    # |> draw()
    |> count_water_squares()
  end

  def count_water_squares({coords, meta}) do
    coords
    |> Enum.to_list()
    # |> Enum.filter(fn {{x, _y}, _} -> x >= meta.min_x end)
    # |> Enum.filter(fn {{x, _y}, _} -> x <= meta.max_x end)
    |> Enum.filter(fn {{_x, y}, _} -> y >= meta.min_y end)
    |> Enum.filter(fn {{_x, y}, _} -> y <= meta.max_y end)
    |> Enum.filter(fn {_, e} -> e == @water || e == @trickle end)
    |> Enum.count()
  end

  def parse_input(stream) do
    coords =
      Enum.reduce(stream, %{}, fn line, acc ->
        parse_line_into_coords(line)
        |> Map.merge(acc)
      end)

    meta = get_meta(coords)
    {coords, meta}
  end

  def trickle_water({coords, meta}, cur) do
    u = underneath(cur)
    {u_x, _u_y} = u

    if {u_x, meta.max_y} >= u do
      case get_square(coords, u) do
        @sand ->
          coords = Map.put(coords, u, @trickle)
          trickle_water({coords, meta}, u)

        @trickle ->
          {coords, meta}

        _ ->
          run_water({coords, meta}, cur)
      end
    else
      {coords, meta}
    end
  end

  def run_water({coords, meta}, cur) do
    l = left(cur)
    ul = underneath(l)
    r = right(cur)
    ur = underneath(r)

    {wall_left?, acc_left, cur_left} =
      run_water_left(
        coords,
        l,
        get_square(coords, l),
        get_square(coords, ul),
        []
      )

    {wall_right?, acc_right, cur_right} =
      run_water_right(
        coords,
        r,
        get_square(coords, r),
        get_square(coords, ur),
        []
      )

    coords_to_update = [cur] ++ acc_left ++ acc_right

    cond do
      wall_left? && wall_right? ->
        coords = Enum.reduce(coords_to_update, coords, fn el, acc -> Map.put(acc, el, @water) end)
        run_water({coords, meta}, above(cur))

      wall_left? ->
        coords =
          Enum.reduce(coords_to_update, coords, fn el, acc -> Map.put(acc, el, @trickle) end)

        trickle_water({coords, meta}, cur_right)

      wall_right? ->
        coords =
          Enum.reduce(coords_to_update, coords, fn el, acc -> Map.put(acc, el, @trickle) end)

        trickle_water({coords, meta}, cur_left)

      true ->
        coords =
          Enum.reduce(coords_to_update, coords, fn el, acc -> Map.put(acc, el, @trickle) end)

        {coords, meta} = trickle_water({coords, meta}, cur_left)
        trickle_water({coords, meta}, cur_right)
    end
  end

  def run_water_left(_coords, cur, _, @sand, acc) do
    {false, [cur] ++ acc, cur}
  end

  def run_water_left(_coords, cur, _, @trickle, acc) do
    {false, [cur] ++ acc, cur}
  end

  def run_water_left(_coords, cur, @clay, _, acc) do
    {true, acc, cur}
  end

  def run_water_left(coords, cur, _c, _, acc) do
    l = left(cur)
    ul = underneath(l)

    run_water_left(
      coords,
      l,
      get_square(coords, l),
      get_square(coords, ul),
      [cur] ++ acc
    )
  end

  def run_water_right(_coords, cur, _, @sand, acc) do
    {false, [cur] ++ acc, cur}
  end

  def run_water_right(_coords, cur, _, @trickle, acc) do
    {false, [cur] ++ acc, cur}
  end

  def run_water_right(_coords, cur, @clay, _, acc) do
    {true, acc, cur}
  end

  def run_water_right(coords, cur, _c, _, acc) do
    r = right(cur)
    ur = underneath(r)

    run_water_right(
      coords,
      r,
      get_square(coords, r),
      get_square(coords, ur),
      [cur] ++ acc
    )
  end

  def underneath({cur_x, cur_y}), do: {cur_x, cur_y + 1}
  def above({cur_x, cur_y}), do: {cur_x, cur_y - 1}
  def left({cur_x, cur_y}), do: {cur_x - 1, cur_y}
  def right({cur_x, cur_y}), do: {cur_x + 1, cur_y}

  def draw({coords, meta}) do
    path = "lib/day17/diagram"
    File.open(path, [:write])

    Enum.each(meta.min_y..meta.max_y, fn y ->
      line =
        Range.new(meta.min_x - 1, meta.max_x + 1)
        |> Enum.map(fn x -> get_square(coords, {x, y}) end)
        |> Enum.join("")

      File.write!(path, line <> "\n", [:append])
    end)

    {coords, meta}
  end

  def get_meta(coords) do
    {{max_x, _}, _} = Enum.max_by(coords, fn {{x, _y}, _} -> x end)
    {{_, max_y}, _} = Enum.max_by(coords, fn {{_x, y}, _} -> y end)
    {{min_x, _}, _} = Enum.min_by(coords, fn {{x, _y}, _} -> x end)
    {{_, min_y}, _} = Enum.min_by(coords, fn {{_x, y}, _} -> y end)
    %{max_x: max_x, min_x: min_x, max_y: max_y, min_y: min_y}
  end

  def parse_line_into_coords(<<"x", _rest::binary>> = line) do
    %{"x" => x, "y1" => y1, "y2" => y2} =
      Regex.named_captures(~r/x=(?<x>.*), y=(?<y1>.*)\.\.(?<y2>.*)/, line)

    Range.new(String.to_integer(y1), String.to_integer(y2))
    |> Enum.map(fn y -> {{String.to_integer(x), y}, @clay} end)
    |> Enum.into(%{})
  end

  def parse_line_into_coords(<<"y", _rest::binary>> = line) do
    %{"x1" => x1, "x2" => x2, "y" => y} =
      Regex.named_captures(~r/y=(?<y>.*), x=(?<x1>.*)\.\.(?<x2>.*)/, line)

    Range.new(String.to_integer(x1), String.to_integer(x2))
    |> Enum.map(fn x -> {{x, String.to_integer(y)}, "#"} end)
    |> Enum.into(%{})
  end

  def get_square(map, square) do
    Map.get(map, square, @sand)
  end
end
