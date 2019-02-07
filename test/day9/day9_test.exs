defmodule Day9Test do
  use ExUnit.Case
  alias Day9.Q1
  alias Day9.Q2

  doctest Q1
  doctest Q2

  # @tag :skip
  test "q1 works with my input" do
    assert File.read!("lib/fixtures/day9_input") |> Q1.run() == 412_959
  end

  # @tag :skip
  test "q2 works with my input" do
    assert File.read!("lib/fixtures/day9_input") |> Q2.run() == 3_333_662_986
  end
end
