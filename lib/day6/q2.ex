defmodule Day6.Q2 do
  @moduledoc """
  Documentation for Day 6 Q2.
  """

  @doc """
  Using only the Manhattan distance, determine the area around each coordinate by
  counting the number of integer X,Y locations that are closest to that coordinate
  (and aren't tied in distance to any other coordinate).

  The goal is to find the size of the largest area that isn't infinite.

  ## Examples

      iex> Q2.run([{1,1}, {2,2}, {2, 3}, {4, 1}],7)
      2
      iex> Q2.run([{1, 1},{1, 6},{8, 3},{3, 4},{5, 5},{8, 9}], 32)
      16

  """
  def run(input_stream, tot_dist_threshold, mode \\ :tuples) do
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

    generate_distances(input_stream, box)
    |> Stream.filter(&Kernel.>(tot_dist_threshold, &1))
    |> Enum.count()
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

  @doc """
  Given list of `{coord, label}` pairings and a bounding box, generate a 2D list of `{coord, label}`
  pairings that will fill the bounding box. The labels that fill the bounding box should be the closest
  manhattan distance to the positions of the input labels, or -1 if there is a tie
  """
  def generate_distances(input_coords, box) do
    for i <- Range.new(box.left, box.right), j <- Range.new(box.top, box.bottom) do
      coord = {i, j}

      Stream.map(
        input_coords,
        &manhattan_distance(coord, &1)
      )
      |> Enum.sum()
    end
  end
end
