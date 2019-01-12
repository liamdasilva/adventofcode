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
      |> find_overlapping_ids()

    with [id] <-
           MapSet.difference(all_ids, intersecting_ids)
           |> MapSet.to_list() do
      id
    else
      _ -> {:error, "No single non overlapping claim"}
    end
  end

  @doc """
  Given a list of claims (`list`), see if there are any intersections
  If there are, return set of all  claims
  """
  def find_overlapping_ids(list) do
    {overlapping, _} =
      Enum.reduce(list, {MapSet.new(), Enum.drop(list, 1)}, fn el, {acc, rest} ->
        intersection_ids = find_overlapping_ids_aux(el, rest)
        {MapSet.union(acc, intersection_ids), Enum.drop(rest, 1)}
      end)

    overlapping
  end

  def find_overlapping_ids_aux(set, list_to_compare) do
    Enum.reduce(list_to_compare, MapSet.new(), fn el, acc ->
      if MapSet.disjoint?(set["coords"], el["coords"]) do
        acc
      else
        MapSet.put(acc, set["id"])
        |> MapSet.put(el["id"])
      end
    end)
  end
end
