defmodule Stack do
  @moduledoc """
  Functions to operate on a Stack
  """
  defstruct size: 0, value: []

  def new() do
    %Stack{}
  end

  def push(stack, element) do
    new_val = [element] ++ stack.value
    size = stack.size + 1
    %Stack{value: new_val, size: size}
  end

  def pop(%Stack{value: []} = stack), do: {nil, stack}

  def pop(stack) do
    {List.first(stack.value), drop_top(stack)}
  end

  def drop_top(%Stack{value: []} = stack), do: stack

  def drop_top(stack) do
    %Stack{stack | value: Enum.drop(stack.value, 1), size: stack.size - 1}
  end

  def peek(stack) do
    List.first(stack.value)
  end

  def size(stack) do
    stack.size
  end

  def pop_all(stack) do
    Enum.reverse(stack.value)
  end
end
