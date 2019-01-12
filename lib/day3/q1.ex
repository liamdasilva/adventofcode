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
    |> Stream.map(&turn_claim_into_coords/1)
    |> find_overlapping()
    |> MapSet.size()
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
      |> Enum.into(MapSet.new())

    %{"coords" => coords, "id" => claim["id"]}
  end

  @doc """
  Given a list of MapSets (`list`), see if there are any intersections
  If there are, return the elements in all intersections
  """
  def find_overlapping(list) do
    {overlapping, _} =
      Enum.reduce(list, {MapSet.new(), Enum.drop(list, 1)}, fn el, {acc, rest} ->
        intersections = find_overlapping_aux(el, rest)
        {MapSet.union(acc, intersections), Enum.drop(rest, 1)}
      end)

    overlapping
  end

  def find_overlapping_aux(set, list_to_compare) do
    Enum.reduce(list_to_compare, MapSet.new(), fn el, acc ->
      intersection = MapSet.intersection(set["coords"], el["coords"])
      MapSet.union(acc, intersection)
    end)
  end
end
