defmodule Day1.Q2 do
  require Logger
  alias Day1.Q1

  @moduledoc """
  Documentation for Day 1 Q2.
  """

  @doc """
  Input: a sequence of changes in frequency, separated by \n or ,
  A value like +6 means the current frequency increases by 6
  A value like -3 means the current frequency decreases by 3.
  Find first repeating frequency
    
  ## Examples

      iex> Q2.run("+1, -1")
      0
      iex> Q2.run("+3, +3, +4, -2, -4")
      10
      iex> Q2.run "-6, +3, +8, +5, -6"
      5
      iex> Q2.run("+7, +7, -2, -7, -4")
      14

  """
  def run(input, mode \\ :inline) do
    with {:ok, stream} <- create_frequency_change_stream(input, mode) do
      find_repeating_frequency(stream)
    else
      e ->
        Logger.error(inspect(e))
    end
  end

  def create_frequency_change_stream(input, :inline) do
    stream =
      Q1.create_list(input)
      |> Stream.cycle()

    {:ok, stream}
  end

  def create_frequency_change_stream(file_name, :file) do
    stream =
      file_name
      |> File.stream!()
      |> Stream.map(&Integer.parse(&1))
      |> Enum.map(fn {num, _} -> num end)
      |> Stream.cycle()

    {:ok, stream}
  end

  def create_frequency_change_stream(_, mode) do
    {:error, "Mode: #{mode} not supported"}
  end

  def find_repeating_frequency(stream) do
    Enum.reduce_while(stream, {0, MapSet.new([0])}, fn el, acc ->
      {current_sum, numbers_seen} = acc
      sum = current_sum + el

      if MapSet.member?(numbers_seen, sum) do
        {:halt, sum}
      else
        {:cont, {sum, MapSet.put(numbers_seen, sum)}}
      end
    end)
  end
end
