defmodule Day1Test do
  use ExUnit.Case
  alias Day1.Q1
  alias Day1.Q2

  doctest Q1
  doctest Q2

  test "q1 works with my input" do
    result =
      "lib/fixtures/day1_input"
      |> File.read!()
      |> Q1.run()

    assert result == 490
  end

  test "q2 works with my input" do
    result =
      "lib/fixtures/day1_input"
      |> Q2.run(:file)

    assert result == 70357
  end
end
