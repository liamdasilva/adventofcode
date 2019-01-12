defmodule Day1Test do
  use ExUnit.Case
  doctest Q1
  doctest Q2

  test "works with my input" do
    result =
      "lib/fixtures/input.txt"
      |> File.read!()
      |> Q1.run()

    assert result == 490
  end

  test "q2 works with my input" do
    result =
      "lib/fixtures/input.txt"
      |> Q2.run(:file)

    assert result == 70357
  end
end
