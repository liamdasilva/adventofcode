defmodule Day17Test do
  use ExUnit.Case
  alias Day17.Q1

  # doctest Q2

  test "q1 works with my input" do
    # assert File.stream!("lib/fixtures/day17_input2") |> Q1.run() == 57

    assert File.stream!("lib/fixtures/day17_input") |> Q1.run() == 31949
  end
end
