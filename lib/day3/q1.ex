defmodule Day3.Q1 do
  @moduledoc """
  Documentation for Day 3 Q1.
  """

  @doc """
  Find overlapping claims of fabric. Return the number of inches that have at least two claims overlapping.
  All claims have an ID and consist of a single rectangle with edges parallel to the edges of the fabric.
  Each claim's rectangle is defined as follows:

  The number of inches between the left edge of the fabric and the left edge of the rectangle.
  The number of inches between the top edge of the fabric and the top edge of the rectangle.
  The width of the rectangle in inches.
  The height of the rectangle in inches.
  A claim like `#123 @ 3,2: 5x4` means that claim ID 123 specifies a rectangle 3 inches from
  the left edge, 2 inches from the top edge, 5 inches wide, and 4 inches tall.

  ## Examples

      iex> Q1.run(["#1 @ 1,3: 4x4", "#2 @ 3,1: 4x4","#3 @ 5,5: 2x2"])
      4

  """
  def run(input_stream) do
    input_stream
    |> Stream.map(&String.trim/1)
    |> Stream.map(&parse_claim/1)
    |> Enum.map(&turn_claim_into_coords/1)
    |> combine_coords()
    |> Map.values()
    |> Stream.filter(fn x -> MapSet.size(x) > 1 end)
    |> Enum.count()
  end

  def parse_claim(claim_string) do
    with [_, _, _, _, _] = claim_list <-
           String.split(claim_string, ~r{(\s|@|x|,|:|#)+}, trim: true) do
      claims =
        claim_list
        |> Enum.map(fn x ->
          {int, _} = Integer.parse(x)
          int
        end)

      ["id", "left", "top", "width", "height"]
      |> Enum.zip(claims)
      |> Enum.into(%{})
    else
      _ ->
        {:error, "Invalid Claim"}
    end
  end

  def turn_claim_into_coords(claim) do
    top_range = Range.new(claim["left"], claim["width"] + claim["left"] - 1)
    left_range = Range.new(claim["top"], claim["top"] + claim["height"] - 1)

    coords =
      for i <- top_range, j <- left_range do
        {i, j}
      end

    %{coords: coords, id: claim["id"]}
  end

  def combine_coords(list) do
    Enum.reduce(list, %{}, fn el, acc ->
      %{coords: coords, id: id} = el

      Enum.reduce(coords, acc, fn coord, a ->
        Map.update(a, coord, MapSet.new([id]), fn x -> MapSet.put(x, id) end)
      end)
    end)
  end
end
