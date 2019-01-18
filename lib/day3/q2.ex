defmodule Day3.Q2 do
  alias Day3.Q1

  @moduledoc """
  Documentation for Day 3 Q2.
  """

  @doc """
  Find the ID of the only claim that doesn't overlap

  ## Examples

      iex> Q2.run(["#1 @ 1,3: 4x4", "#2 @ 3,1: 4x4","#3 @ 5,5: 2x2"])
      3

  """
  def run(input_stream) do
    claim =
      input_stream
      |> Stream.map(&String.trim/1)
      |> Stream.map(&Q1.parse_claim/1)

    all_ids =
      claim
      |> Stream.map(fn x -> x["id"] end)
      |> Enum.into(MapSet.new())

    intersecting_ids =
      claim
      |> Stream.map(&Q1.turn_claim_into_coords/1)
      |> Q1.combine_coords()
      |> Map.values()
      |> Stream.filter(fn x -> MapSet.size(x) > 1 end)
      |> Enum.reduce(MapSet.new(), fn el, acc -> MapSet.union(el, acc) end)

    with [id] <-
           MapSet.difference(all_ids, intersecting_ids)
           |> MapSet.to_list() do
      id
    else
      _ -> {:error, "No single non overlapping claim"}
    end
  end
end
