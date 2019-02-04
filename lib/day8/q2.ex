defmodule Day8.Q2 do
  @moduledoc """
  Documentation for Day 8 Q2.
  """

  @doc """
  2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2
  A----------------------------------
    B----------- C-----------
                     D-----
  For example, again using the above nodes:

  Node C has one metadata entry, 2. Because node C has only one child node, 2 references a child node which does not exist, and so the value of node C is 0.
  Node A has three metadata entries: 1, 1, and 2. The 1 references node A's first child node, B, and the 2 references node A's second child node, C. Because node B has a value of 33 and node C has a value of 0, the value of node A is 33+33+0=66.
  So, in this example, the value of the root node is 66.

  ## Examples

      iex> Q2.run("2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2")
      66

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
    {children, rest} = parse_children(num_children, rest)
    parse_metadata(num_metadata, rest, children)
  end

  def parse_children(num_children, list) do
    Range.new(1, num_children)
    |> Enum.reduce({%{}, list}, fn el, acc ->
      {children, list} = acc
      {sum, rest} = parse_node_aux(list)
      {Map.put(children, el, sum), rest}
    end)
  end

  def parse_metadata(num_metadata, list) do
    Range.new(1, num_metadata)
    |> Enum.reduce({0, list}, fn _el, acc ->
      {sum, [a | list]} = acc
      {sum + a, list}
    end)
  end

  def parse_metadata(num_metadata, list, children) do
    Range.new(1, num_metadata)
    |> Enum.reduce({0, list}, fn _el, acc ->
      {sum, [a | list]} = acc
      val = Map.get(children, a, 0)
      {sum + val, list}
    end)
  end
end
