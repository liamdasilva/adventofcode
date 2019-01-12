defmodule Day2.Q1 do
  @moduledoc """
  Documentation for Day 2 Q1.
  """

  @doc """
  Finds checksum of list of ids
  Checksum is calculated by counting the number that have an ID containing 
  exactly two of any letter and then separately counting those with 
  exactly three of any letter. You can multiply those two counts together 
  to get a rudimentary checksum
    
  ## Examples

      iex> Q1.run(["abcdef","bababc","abbcde","abcccd","aabcdd","abcdee","ababab"])
      12

  """
  def run(input_stream) do
    counts =
      Stream.map(input_stream, &letter_count/1)
      |> Stream.map(&convert_values_to_keys/1)
      |> Enum.reduce(%{}, fn el, acc ->
        Map.merge(acc, el, fn _k, v1, v2 ->
          v1 + v2
        end)
      end)

    counts[2] * counts[3]
  end

  def letter_count(word) do
    String.graphemes(word)
    |> Enum.reduce(%{}, fn el, acc ->
      Map.update(acc, el, 1, fn val -> val + 1 end)
    end)
  end

  def convert_values_to_keys(map) do
    Enum.reduce(map, %{}, fn {_key, value}, acc ->
      Map.put_new(acc, value, 1)
    end)
  end
end
