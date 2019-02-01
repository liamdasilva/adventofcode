defmodule Day7Test do
  use ExUnit.Case
  alias Day7.Q1
  alias Day7.Q2

  doctest Q1
  doctest Q2

  @tag :skip
  test "q1 works with my input" do
    assert File.stream!("lib/fixtures/day7_input") |> Q1.run() == "ACHOQRXSEKUGMYIWDZLNBFTJVP"
  end

  test "q2 works with my input" do
    assert File.stream!("lib/fixtures/day7_input") |> Q2.run(5) == "AHQXCORUSEKGYZMWIDLNBTFJVP"
  end
end
