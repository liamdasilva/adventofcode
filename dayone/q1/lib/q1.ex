defmodule Q1 do
  @moduledoc """
  Documentation for Q1.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Q1.hello()
      :world

  """
  def run(input) do
    input
    |> create_list()
    |> Enum.sum()
  end

  def create_list(string) do
    String.split(string, "\n")
    |> Stream.map(&Integer.parse(&1))
    |> Enum.map(fn {num, _} -> num end)
  end
end
