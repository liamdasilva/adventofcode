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

      iex> Q1.run([{1,1}, {2,2}, {2, 3}, {4, 1}])
      2
      iex> Q1.run([{1, 1},{1, 6},{8, 3},{3, 4},{5, 5},{8, 9}])
      17

  """
  def run(input_stream, mode \\ :tuples) do
    # if not in tuples mode, convert string input into tuples
    input_stream =
      if mode != :tuples do
        input_stream
        |> Stream.map(&String.trim/1)
        |> Stream.map(&String.split(&1, ~r{(,|\s)+}))
        |> Enum.map(fn [a, b] ->
          {a, _} = Integer.parse(a)
          {b, _} = Integer.parse(b)
          {a, b}
        end)
      else
        input_stream
      end

    box = bounding_box(input_stream)

    input_with_labels =
      input_stream
      |> Enum.with_index()

    pairings = generate_closest_coords(input_with_labels, box)

    labels_to_exclude =
      Stream.filter(pairings, fn {coord, _label} ->
        is_on_edge?(coord, box)
      end)
      |> Stream.map(fn {_coord, label} -> label end)
      |> Enum.into(MapSet.new())

    {_key, val} =
      pairings
      |> Stream.filter(fn {_coord, label} -> not MapSet.member?(labels_to_exclude, label) end)
      |> Stream.map(fn {_coord, label} -> label end)
      |> Enum.reduce(%{}, fn el, acc -> Map.update(acc, el, 1, &Kernel.+(1, &1)) end)
      |> Enum.max_by(fn {_key, val} -> val end)

    val
  end

  @doc """
  Return bounding box that surrounds all given coords in
  the format `{top left coord, bottom right coord}`
  """
  def bounding_box(coords) do
    Enum.reduce(coords, %{}, fn coord, box ->
      {a, b} = coord

      Map.update(box, :top, b, &min(b, &1))
      |> Map.update(:bottom, b, &max(b, &1))
      |> Map.update(:left, a, &min(a, &1))
      |> Map.update(:right, a, &max(a, &1))
    end)
  end

  def is_on_edge?({a, b}, box) do
    a == box.left || a == box.right || b == box.top || b == box.bottom
  end

  def manhattan_distance({a, b}, {c, d}) do
    abs(a - c) + abs(b - d)
  end

  @doc """
  Given list of `{coord, label}` pairings and a bounding box, generate a 2D list of `{coord, label}`
  pairings that will fill the bounding box. The labels that fill the bounding box should be the closest
  manhattan distance to the positions of the input labels, or -1 if there is a tie
  """
  def generate_closest_coords(input_coords, box) do
    for i <- Range.new(box.left, box.right), j <- Range.new(box.top, box.bottom) do
      coord = {i, j}

      distances =
        Enum.map(input_coords, fn {x, index} ->
          {manhattan_distance(coord, x), index}
        end)

      start_val = {List.first(distances), false}

      {{_min, i}, dupes?} =
        distances
        |> Enum.drop(1)
        |> Enum.reduce(start_val, fn {dist, _} = el, acc ->
          {{val, _}, _} = acc

          cond do
            dist < val ->
              {el, false}

            dist == val ->
              {el, true}

            true ->
              acc
          end
        end)

      if dupes? do
        {coord, -1}
      else
        {coord, i}
      end
    end
  end
end
