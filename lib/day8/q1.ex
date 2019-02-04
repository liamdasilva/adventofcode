defmodule Day8.Q1 do
  @moduledoc """
  Documentation for Day 8 Q1.
  """

  @doc """
  2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2
  A----------------------------------
    B----------- C-----------
                     D-----
  In this example, each node of the tree is also marked with an underline starting with a letter for easier identification. In it, there are four nodes:

  A, which has 2 child nodes (B, C) and 3 metadata entries (1, 1, 2).
  B, which has 0 child nodes and 3 metadata entries (10, 11, 12).
  C, which has 1 child node (D) and 1 metadata entry (2).
  D, which has 0 child nodes and 1 metadata entry (99).

  ## Examples

      iex> Q1.run("2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2")
      138

  """
  def run(input) do
    String.split(input)
    |> Enum.map(fn x ->
      {i, _} = Integer.parse(x)
      i
    end)
    |> parse_node()
  end

  def parse_node(list) do
    {sum, _leftover} = parse_node_aux(list)
    sum
  end

  def parse_node_aux([0, num_metadata | rest]) do
    parse_metadata(num_metadata, rest)
  end

  def parse_node_aux([num_children, num_metadata | rest]) do
    {sum_children, rest} = parse_children(num_children, rest)
    {sum_metadata, rest} = parse_metadata(num_metadata, rest)
    {sum_children + sum_metadata, rest}
  end

  def parse_children(num_children, list) do
    Range.new(1, num_children)
    |> Enum.reduce({0, list}, fn _el, acc ->
      {cur_sum, list} = acc
      {sum, rest} = parse_node_aux(list)
      {cur_sum + sum, rest}
    end)
  end

  def parse_metadata(num_metadata, list) do
    Range.new(1, num_metadata)
    |> Enum.reduce({0, list}, fn _el, acc ->
      {sum, [a | list]} = acc
      {sum + a, list}
    end)
  end
end
