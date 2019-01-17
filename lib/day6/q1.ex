defmodule Day6.Q1 do
  @moduledoc """
  Documentation for Day 6 Q1.
  """

  @doc """
  Using only the Manhattan distance, determine the area around each coordinate by 
  counting the number of integer X,Y locations that are closest to that coordinate 
  (and aren't tied in distance to any other coordinate).

  The goal is to find the size of the largest area that isn't infinite.
    
  ## Examples

      iex> Q1.run([{1, 1},{1, 6},{8, 3},{3, 4},{5, 5},{8, 9}])
      17

  """
  def run(input_stream) do
    box = bounding_box(input_stream)

    input =
      input_stream
      |> Enum.with_index()

    for i <- Range.new(box.left, box.right), j <- Range.new(box.top, box.bottom) do
      coord = {i, j}

      distances =
        Enum.map(input, fn {x, index} ->
          {manhattan_distance(coord, x), index}
        end)

      start_val = List.first(distances)

      {min, dupes?} =
        distances
        |> Enum.drop(1)
        |> Enum.reduce({start_val, false}, fn el, acc ->
          {val, _} = acc

          cond do
            el < val ->
              {el, false}

            el == val ->
              {el, true}

            true ->
              acc
          end
        end)

      if dupes? do
        {coord, -1}
      else
        {coord, min}
      end
    end
  end

  @doc """
  Return bounding box that surrounds all given coords in 
  the format `{top left coord, bottom right coord}`
  """
  def bounding_box(coords) do
    Enum.reduce(coords, %{}, fn coord, box ->
      {a, b} = coord

      Map.update(box, :top, b, &Enum.min([b, &1]))
      |> Map.update(:bottom, b, &Enum.max([b, &1]))
      |> Map.update(:left, a, &Enum.min([a, &1]))
      |> Map.update(:right, a, &Enum.max([a, &1]))
    end)
  end

  def is_on_edge?({a, b}, box) do
    a == box.left || a == box.right || b == box.top || b == box.bottom
  end

  def manhattan_distance({a, b}, {c, d}) do
    abs(a - c) + abs(b - d)
  end
end
