defmodule Day7.Q2 do
  @moduledoc """
  Documentation for Day 7 Q2.
  """
  alias Day7.Q1

  @doc """
  As you're about to begin construction, four of the Elves offer to help. "The sun will set soon;
  it'll go faster if we work together." Now, you need to account for multiple people working on steps
  simultaneously. If multiple steps are available, workers should still begin them in alphabetical order.

  Each step takes 60 seconds plus an amount corresponding to its letter: A=1, B=2, C=3, and so on.
  So, step A takes 60+1=61 seconds, while step Z takes 60+26=86 seconds. No time is required between steps.
  With 5 workers and the 60+ second step durations described above, how long will it take to complete all of the steps?

  ## Examples

      iex> Q2.run(["Step C must be finished before step A can begin.","Step C must be finished before step F can begin.","Step A must be finished before step B can begin.","Step A must be finished before step D can begin.","Step B must be finished before step E can begin.","Step D must be finished before step E can begin.","Step F must be finished before step E can begin."], 2)
      "CAFBDE"

  """
  def run(input_stream, num_workers \\ 2) do
    {sequence, _time} =
      input_stream
      |> Enum.map(&Q1.parse_sentence/1)
      |> Q1.convert_to_graph()
      |> process_graph(num_workers)

    sequence
  end

  def process_graph(graph, num_workers \\ 2) do
    process_graph_aux(graph, MapSet.new(), [], create_workers(num_workers), "", 0)
  end

  defp process_graph_aux(graph, _done, _available, _workers, sequence, time_ticked)
       when graph == %{} do
    {sequence, time_ticked}
  end

  defp process_graph_aux(graph, done, available, workers, sequence, time_ticked) do
    {new_graph, new_available} =
      Enum.reduce(graph, {graph, available}, fn {child, parents}, acc ->
        {g, available} = acc

        if MapSet.subset?(parents, done) do
          {Map.delete(g, child), [child] ++ available}
        else
          acc
        end
      end)

    {new_available, workers} = assign_to_workers(new_available, workers)

    {workers, done_string, ticked} = tick(workers)

    done =
      done_string
      |> String.graphemes()
      |> Enum.reduce(done, &MapSet.put(&2, &1))

    # IO.puts("NEW GRAPH")
    # IO.inspect(new_graph)
    # IO.puts("NEW AVAILABLE")
    # IO.inspect(new_available)
    # IO.puts("TO_DO")
    # IO.inspect(to_do)

    process_graph_aux(
      new_graph,
      done,
      new_available,
      workers,
      sequence <> done_string,
      time_ticked + ticked
    )
  end

  @doc """
  Assign available tasks to free workers

  ## Examples

      iex> Q2.assign_to_workers(["B", "A"], %{1 => {"C", 32}, 2 => nil})
      {["B"], %{1 => {"C", 32}, 2 => {"A", 61}}}
      iex> Q2.assign_to_workers(["B", "A"], %{1 => {"C", 32}, 2 => nil, 3 => nil})
      {[], %{1 => {"C", 32}, 2 => {"A", 61}, 3 => {"B", 62}}}
      iex> Q2.assign_to_workers([], %{1 => {"C", 32}, 2 => nil, 3 => nil})
      {[], %{1 => {"C", 32}, 2 => nil, 3 => nil}}

  """
  def assign_to_workers([], workers) do
    {[], workers}
  end

  def assign_to_workers(available, workers) do
    case get_idle_worker_ids(workers) do
      [] ->
        {available, workers}

      ids ->
        Enum.reduce_while(ids, {Enum.sort(available), workers}, fn id, acc ->
          {a_left, w} = acc

          case a_left do
            [] ->
              {:halt, {[], w}}

            [to_do | a] ->
              task = {to_do, get_task_time(to_do)}
              w = Map.put(w, id, task)
              {:cont, {a, w}}
          end
        end)
    end
  end

  def tick(workers) do
    tick_aux(workers, "", 0)
  end

  defp tick_aux(workers, "", time_ticked) do
    {new_workers, done_string} =
      Enum.reduce(workers, {workers, ""}, fn
        {_id, nil}, acc ->
          acc

        {worker_id, {task_name, task_time}}, acc ->
          {w, done_string} = acc

          case task_time do
            1 -> {Map.put(w, worker_id, nil), done_string <> task_name}
            time -> {Map.put(w, worker_id, {task_name, time - 1}), done_string}
          end
      end)

    tick_aux(new_workers, done_string, time_ticked + 1)
  end

  defp tick_aux(workers, done, time_ticked) do
    {workers, done, time_ticked}
  end

  @doc """
  Convert Step to task time. Step A takes 60+1=61 seconds, while step Z takes 60+26=86 seconds

  ## Examples

      iex> Q2.get_task_time("A")
      61
      iex> Q2.get_task_time("z")
      86

  """
  def get_task_time(task) do
    String.upcase(task) |> String.to_charlist() |> List.first() |> Kernel.-(4)
  end

  def create_workers(num) do
    Range.new(1, num)
    |> Enum.map(fn x -> {x, nil} end)
    |> Enum.into(%{})
  end

  def get_idle_worker_ids(workers) do
    workers
    |> Stream.filter(fn {_key, value} -> value == nil end)
    |> Enum.map(fn {key, _value} -> key end)
  end
end
