defmodule Day3Test do
  use ExUnit.Case
  alias Day3.Q1
  alias Day3.Q2

  doctest Q1
  doctest Q2

  # these tests take too long to run, skipping them

  @tag :skip
  test "q1 works with my input" do
    assert File.stream!("lib/fixtures/day3_input") |> Q1.run() == 110_891
  end

  @tag :skip
  test "q2 works with my input" do
    assert File.stream!("lib/fixtures/day3_input") |> Q2.run() == 297
  end
end
