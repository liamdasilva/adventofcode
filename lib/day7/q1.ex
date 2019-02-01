defmodule Day7.Q1 do
  @moduledoc """
  Documentation for Day 7 Q1.
  """

  @doc """
  The instructions specify a series of steps and requirements about which steps must be finished before
  others can begin (your puzzle input). Each step is designated by a single letter.
  Determine the order in which the steps should be completed. If more than one step is ready,
  choose the step which is first alphabetically.

  ## Examples

      iex> Q1.run(["Step C must be finished before step A can begin.","Step C must be finished before step F can begin.","Step A must be finished before step B can begin.","Step A must be finished before step D can begin.","Step B must be finished before step E can begin.","Step D must be finished before step E can begin.","Step F must be finished before step E can begin."])
      "CABDFE"

  """
  def run(input_stream) do
    input_stream
    |> Enum.map(&parse_sentence/1)
    |> convert_to_graph()
    |> process_graph()
  end

  def process_graph(graph) do
    process_graph_aux(graph, MapSet.new(), [], "")
  end

  defp process_graph_aux(graph, done, available, sequence) when graph == %{} do
    sequence
  end

  defp process_graph_aux(graph, done, available, sequence) do
    {new_graph, new_available} =
      Enum.reduce(graph, {graph, available}, fn {child, parents}, acc ->
        {g, available} = acc

        if MapSet.subset?(parents, done) do
          {Map.delete(g, child), [child] ++ available}
        else
          acc
        end
      end)

    [to_do | new_available] = Enum.sort(new_available)

    # IO.puts("NEW GRAPH")
    # IO.inspect(new_graph)
    # IO.puts("NEW AVAILABLE")
    # IO.inspect(new_available)
    # IO.puts("TO_DO")
    # IO.inspect(to_do)

    process_graph_aux(
      new_graph,
      MapSet.put(done, to_do),
      new_available,
      sequence <> to_do
    )
  end

  def parse_sentence(sentence) do
    <<"Step ", a::binary-size(1), " must be finished before step ", b::binary-size(1),
      " can begin.">> = String.trim(sentence)

    {a, b}
  end

  @doc """
  Converts a list of tuples into a directed acyclic graph representation.
  Input: list of `{a, b}` where a needs to be done before b
  Output: map, where each key is the step that can only be done after the steps in it's value
   (which is a MapSet)
  """
  def convert_to_graph(enum) do
    Enum.reduce(enum, %{}, fn {a, b}, acc ->
      Map.update(acc, b, MapSet.new([a]), &MapSet.put(&1, a))
      |> Map.put_new(a, MapSet.new())
    end)
  end
end
