defmodule Q1 do
  @moduledoc """
  Documentation for Day 1 Q1.
  """

  @doc """
  Input: a sequence of changes in frequency, one value per line
  A value like +6 means the current frequency increases by 6
  A value like -3 means the current frequency decreases by 3.
    
  ## Examples

      iex> Q1.run("-2\\n+4\\n-3")
      -1
      iex> Q1.run("+6\\n-9\\n+8")
      5

  """
  def run(input) do
    input
    |> create_list()
    |> Enum.sum()
  end

  def create_list(string) do
    String.split(string, ~r{(\n|,|\s)+}, trim: true)
    |> Stream.map(&Integer.parse(&1))
    |> Enum.map(fn {num, _} -> num end)
  end
end
