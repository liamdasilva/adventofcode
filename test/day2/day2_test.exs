defmodule Day2Test do
  use ExUnit.Case
  alias Day2.Q1
  alias Day2.Q2

  doctest Q1
  doctest Q2

  test "q1 works with my input" do
    assert File.stream!("lib/fixtures/day2_input") |> Q1.run() == 7904
  end

  test "q2 works with my input" do
    assert File.stream!("lib/fixtures/day2_input") |> Q2.run() == "wugbihckpoymcpaxefotvdzns"
  end
end
