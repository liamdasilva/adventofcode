defmodule Day5Test do
  use ExUnit.Case
  alias Day5.Q1
  alias Day5.Q2

  doctest Q1
  doctest Q2

  test "q1 works with my input" do
    assert File.read!("lib/fixtures/day5_input") |> Q1.run() == 9060
  end

  test "q2 works with my input" do
    assert File.read!("lib/fixtures/day5_input") |> Q2.run() == 6310
  end
end
