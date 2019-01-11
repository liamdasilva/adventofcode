defmodule Q1Test do
  use ExUnit.Case
  doctest Q1

  test "greets the world" do
    assert Q1.hello() == :world
  end
end
