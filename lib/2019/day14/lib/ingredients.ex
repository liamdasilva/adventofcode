defmodule Ingredients do
  def run(file_path) do
    weights_map = parse_input(file_path)
    graph = create_graph(weights_map)

    order = process_graph(graph)

    process_in_order(order, weights_map, %{"FUEL" => 1})
  end

  def process_in_order(order, weights_map, needed) do
    Enum.reduce(order, {needed, %{}}, fn el, acc ->
      {needed_map, leftover_map} = acc
      {needed_amount, needed_map} = Map.pop(needed_map, el)

      {needed_map, leftover_map} =
        Enum.reduce(weights_map[el].data, {needed_map, leftover_map}, fn {k, v}, acc ->
          {result_map, leftover_map} = acc
          {leftover, leftover_map} = Map.pop(leftover_map, k, 0)
          leftover_to_use = div(leftover, v)
          leftover = rem(leftover, v)
          needed_amount = needed_amount - leftover_to_use
          result = v * ceil(needed_amount / weights_map[el].amount)

          leftover =
            ceil(needed_amount / weights_map[el].amount) * weights_map[el].amount - needed_amount +
              leftover

          result_map = Map.update(result_map, k, result, &(&1 + result))

          {result_map, Map.put(leftover_map, el, leftover)}
        end)
        |> IO.inspect()
    end)
  end

  def create_graph(map) do
    Enum.map(map, fn {k, v} ->
      children = Map.keys(v.data) |> Enum.into(MapSet.new())
      {k, children}
    end)
    |> Enum.into(%{})
    |> Map.put("ORE", MapSet.new())
  end

  def parse_input(path) do
    File.read!(path)
    |> String.split("\n")
    |> Enum.map(fn line ->
      [ingredient_string, result_string] = String.split(line, "=>")
      ingredient_list = String.trim(ingredient_string) |> String.split(",")

      ingredients_map =
        Enum.map(ingredient_list, fn el ->
          [amount, ingredient] = String.trim(el) |> String.split(" ")
          {ingredient, String.to_integer(amount)}
        end)
        |> Enum.into(%{})

      [amount, result] = String.trim(result_string) |> String.split(" ")
      map = %{amount: String.to_integer(amount), data: ingredients_map}
      {result, map}
    end)
    |> Enum.into(%{})
    |> Map.put("ORE", %{amount: 1, data: %{}})
  end

  def process_graph(graph) do
    process_graph_aux(graph, MapSet.new(), [], [])
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

    process_graph_aux(
      new_graph,
      MapSet.put(done, to_do),
      new_available,
      [to_do | sequence]
    )
  end
end
