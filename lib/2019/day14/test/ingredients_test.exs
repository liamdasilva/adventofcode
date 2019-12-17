defmodule IngredientsTest do
  use ExUnit.Case
  doctest Ingredients

  test "greets the world" do
    assert Ingredients.hello() == :world
  end
end
