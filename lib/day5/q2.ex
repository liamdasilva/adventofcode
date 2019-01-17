defmodule Day5.Q2 do
  @moduledoc """
  Documentation for Day 5 Q2.
  """

  @regex_filters [
    ~r/a/i,
    ~r/b/i,
    ~r/c/i,
    ~r/d/i,
    ~r/e/i,
    ~r/f/i,
    ~r/g/i,
    ~r/h/i,
    ~r/i/i,
    ~r/j/i,
    ~r/k/i,
    ~r/l/i,
    ~r/m/i,
    ~r/n/i,
    ~r/o/i,
    ~r/p/i,
    ~r/q/i,
    ~r/r/i,
    ~r/s/i,
    ~r/t/i,
    ~r/u/i,
    ~r/v/i,
    ~r/w/i,
    ~r/x/i,
    ~r/y/i,
    ~r/z/i
  ]

  import Day5.Q1

  @doc """
  One of the unit types is causing problems;
  it's preventing the polymer from collapsing as much as it should.
  Your goal is to figure out which unit type is causing the most problems,
  remove all instances of it (regardless of polarity), fully react the
  remaining polymer, and measure its length.

  Assumptions:  1.

  ## Examples

      iex> Q2.run("dabAcCaCBAcCcaDA")
      4

  """
  def run(input) do
    @regex_filters
    |> Enum.map(fn regex ->
      Regex.replace(regex, input, "")
      |> react_polymer
    end)
    |> Enum.min_by(&String.length/1)
    |> String.length()
  end
end
