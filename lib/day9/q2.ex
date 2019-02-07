defmodule Day9.Q2 do
  @moduledoc """
  Documentation for Day 9 Q2.
  """

  alias Day9.Q1

  @doc """

      iex> Q2.run("13 players; last marble is worth 7999 points")
      1406506154
  """
  def run(input) do
    map = Q1.parse_input(input)

    map = %{map | last: map.last * 100}

    Q1.play_game(map)
    |> Stream.map(fn {_, v} -> v end)
    |> Enum.max()
  end
end
