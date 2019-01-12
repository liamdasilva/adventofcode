defmodule Day2.Q2 do
  @moduledoc """
  Documentation for Day 2 Q2.
  """

  @doc """
  Finds almost matching ids, whose characters differ only in one location
    
  ## Examples

      iex> Q2.run(["abcde\\n","fghij","klmno","pqrst","fguij","axcye","wvxyz"])
      "fgij"
      iex> Q2.run(["cba", "dbc", "lde", "sle", "cha"])
      "ca"

  """
  def run(input_stream) do
    # convert ids into grapheme lists
    stream =
      input_stream
      |> Stream.map(&String.trim/1)
      |> Stream.map(&String.graphemes/1)

    # calculate the length of intersection required
    overlap_required = stream |> Enum.at(0) |> length() |> Kernel.-(1)

    stream
    # convert grapheme lists into mapsets as {letter, index} tuples
    |> Stream.map(fn x -> Enum.with_index(x) |> Enum.into(MapSet.new()) end)
    |> find_overlapping(overlap_required)
    # sort result by index, since MapSets do not retain order
    |> Enum.map(fn {x, i} -> {i, x} end)
    |> Enum.sort()
    |> Enum.reduce("", fn {_i, letter}, acc -> acc <> letter end)
  end

  @doc """
  Given a list of MapSets (`list`), find out if any of its elements have an intersection 
  with each other of length `overlap`
  If any do, return the first intersection
  """
  def find_overlapping(list, overlap) do
    Enum.reduce_while(list, Enum.drop(list, 1), fn el, acc ->
      case find_overlapping_aux(el, acc, overlap) do
        {true, intersection} ->
          {:halt, intersection}

        {false, _} ->
          {:cont, Enum.drop(acc, 1)}
      end
    end)
  end

  def find_overlapping_aux(set, list_to_compare, overlap) do
    Enum.reduce_while(list_to_compare, {false, MapSet.new()}, fn el, acc ->
      intersection = MapSet.intersection(set, el)

      case MapSet.size(intersection) do
        ^overlap ->
          {:halt, {true, intersection}}

        _ ->
          {:cont, acc}
      end
    end)
  end
end
