defmodule Day4Test do
  use ExUnit.Case
  alias Day4.Q1
  alias Day4.Q2

  doctest Q1
  doctest Q2

  test "q1 works with my input" do
    assert File.stream!("lib/fixtures/day4_input") |> Q1.run() == 74743
  end

  test "q2 works with my input" do
    assert File.stream!("lib/fixtures/day4_input") |> Q2.run() == 132_484
  end
end
