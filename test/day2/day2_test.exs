defmodule Day2Test do
  use ExUnit.Case
  alias Day2.Q1

  doctest Q1

  test "q1 works with my input" do
    assert File.stream!("lib/fixtures/day2_input.txt") |> Q1.run() == 7904
  end
end
