defmodule Day6Test do
  use ExUnit.Case
  alias Day6.Q1
  alias Day6.Q2

  doctest Q1
  doctest Q2

  test "q1 works with my input" do
    assert File.stream!("lib/fixtures/day6_input") |> Q1.run(:string) == 2906
  end

  test "q2 works with my input" do
    assert File.stream!("lib/fixtures/day6_input") |> Q2.run(10000, :string) == 50530
  end
end
