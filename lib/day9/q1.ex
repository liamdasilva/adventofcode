defmodule Day9.Q1 do
  @moduledoc """
  Documentation for Day 9 Q1.
  """

  @doc """
  Elf marble game.
  For example, suppose there are 9 players. After the marble with value 0 is placed in the middle,
  each player (shown in square brackets) takes a turn. The result of each of those turns would produce
  circles of marbles like this, where clockwise is to the right and the resulting current marble is in parentheses:

  [-] (0)
  [1]  0 (1)
  [2]  0 (2) 1
  [3]  0  2  1 (3)
  [4]  0 (4) 2  1  3
  [5]  0  4  2 (5) 1  3
  [6]  0  4  2  5  1 (6) 3
  [7]  0  4  2  5  1  6  3 (7)
  [8]  0 (8) 4  2  5  1  6  3  7
  [9]  0  8  4 (9) 2  5  1  6  3  7
  [1]  0  8  4  9  2(10) 5  1  6  3  7
  [2]  0  8  4  9  2 10  5(11) 1  6  3  7
  [3]  0  8  4  9  2 10  5 11  1(12) 6  3  7
  [4]  0  8  4  9  2 10  5 11  1 12  6(13) 3  7
  [5]  0  8  4  9  2 10  5 11  1 12  6 13  3(14) 7
  [6]  0  8  4  9  2 10  5 11  1 12  6 13  3 14  7(15)
  [7]  0(16) 8  4  9  2 10  5 11  1 12  6 13  3 14  7 15
  [8]  0 16  8(17) 4  9  2 10  5 11  1 12  6 13  3 14  7 15
  [9]  0 16  8 17  4(18) 9  2 10  5 11  1 12  6 13  3 14  7 15
  [1]  0 16  8 17  4 18  9(19) 2 10  5 11  1 12  6 13  3 14  7 15
  [2]  0 16  8 17  4 18  9 19  2(20)10  5 11  1 12  6 13  3 14  7 15
  [3]  0 16  8 17  4 18  9 19  2 20 10(21) 5 11  1 12  6 13  3 14  7 15
  [4]  0 16  8 17  4 18  9 19  2 20 10 21  5(22)11  1 12  6 13  3 14  7 15
  [5]  0 16  8 17  4 18(19) 2 20 10 21  5 22 11  1 12  6 13  3 14  7 15
  [6]  0 16  8 17  4 18 19  2(24)20 10 21  5 22 11  1 12  6 13  3 14  7 15
  [7]  0 16  8 17  4 18 19  2 24 20(25)10 21  5 22 11  1 12  6 13  3 14  7 15

  The goal is to be the player with the highest score after the last marble is used up. Assuming the example
  above ends after the marble numbered 25, the winning score is 23+9=32 (because player 5 kept marble 23 and
  removed marble 9, while no other player got any points in this very short example game)

  ## Examples

      iex> Q1.run("10 players; last marble is worth 1618 points")
      8317

  """
  def run(input) do
    parse_input(input)
    |> play_game()
  end

  def parse_input(string) do
    {players, rest} = Integer.parse(string)
    <<" players; last marble is worth ", rest::binary>> = rest
    {last, _rest} = Integer.parse(rest)
    %{last: last, players: players}
  end

  def play_game(%{last: last, players: players}) do
    Range.new(1, last)
    |> Enum.reduce({new_game_state(), %{}}, fn marble, {game_state, player_scores} ->
      nil
    end)
  end

  def new_game_state() do
    %{list: [0], size: 1, index: 0}
  end

  def insert_marble(%{list: list, size: size, index: index}, marble) do
    index = index + 2

    size = size + 1
    list = List.insert_at(list, index, marble)
    %{index: index, size: size, list: list}
  end
end
