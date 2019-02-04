defmodule Day8Test do
  use ExUnit.Case
  alias Day8.Q1
  alias Day8.Q2

  doctest Q1
  doctest Q2

  test "q1 works with my input" do
    assert File.read!("lib/fixtures/day8_input") |> Q1.run() == 36566
  end

  test "q2 works with my input" do
    assert File.read!("lib/fixtures/day8_input") |> Q2.run() == 30548
  end
end
