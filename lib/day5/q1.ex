defmodule Day5.Q1 do
  @moduledoc """
  Documentation for Day 5 Q1.
  """

  @doc """

  React the given polymer and return its final length

  Assumptions:  1. Input is always alphabetic

  ## Examples

      iex> Q1.run("dabAcCaCBAcCcaDA")
      10
      iex> Q1.run("aabAAB")
      6
      iex> Q1.run("abBA")
      0

  """
  def run(input) do
    react_polymer(input)
    |> String.length()
  end

  def react_polymer(input) do
    String.trim(input)
    |> String.to_charlist()
    |> Enum.reduce(Stack.new(), fn x, acc ->
      if is_polymer_pair?(Stack.peek(acc), x) do
        Stack.drop_top(acc)
      else
        Stack.push(acc, x)
      end
    end)
    |> Stack.pop_all()
    |> List.to_string()
  end

  def is_polymer_pair?(nil, _), do: false
  def is_polymer_pair?(_, nil), do: false

  def is_polymer_pair?(a, b) when is_binary(a) do
    a = String.to_charlist(a) |> List.first()
    b = String.to_charlist(b) |> List.first()
    a + 32 == b || a - 32 == b
  end

  def is_polymer_pair?(a, b) do
    a + 32 == b || a - 32 == b
  end
end
