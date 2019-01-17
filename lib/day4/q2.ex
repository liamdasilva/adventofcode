defmodule Day4.Q2 do
  @moduledoc """
  Documentation for Day 4 Q2.
  """

  import Day4.Q1

  @doc """
  Find the guard who is most frequently asleep on the same minute
  Return the ID of the guard you chose multiplied by the minute you chose.

  Assumptions:  1. The logs may be out of order
                2. Each time a guard begins a shift, it is a new day's shift
                3. Input logs are all correctly formatted
  ## Examples

      iex> Q2.run(["[1518-11-01 00:05] falls asleep","[1518-11-01 00:25] wakes up","[1518-11-01 00:30] falls asleep","[1518-11-01 00:55] wakes up","[1518-11-01 23:58] Guard #99 begins shift","[1518-11-02 00:40] falls asleep","[1518-11-02 00:50] wakes up","[1518-11-03 00:05] Guard #10 begins shift","[1518-11-03 00:24] falls asleep","[1518-11-03 00:29] wakes up","[1518-11-04 00:02] Guard #99 begins shift","[1518-11-04 00:36] falls asleep","[1518-11-04 00:46] wakes up","[1518-11-05 00:03] Guard #99 begins shift","[1518-11-05 00:45] falls asleep","[1518-11-05 00:55] wakes up","[1518-11-01 00:00] Guard #10 begins shift"])
      4455

  """
  def run(input_stream) do
    minute_counts =
      Enum.sort(input_stream)
      |> Enum.map(&parse_log/1)
      |> process_logs()
      |> combine_logs()

    {id, minute, _} =
      Enum.map(minute_counts, fn {id, map} ->
        {minute, count} = Enum.max_by(map, fn {_, count} -> count end)
        {id, minute, count}
      end)
      |> Enum.max_by(fn {_, _, count} -> count end)

    minute * id
  end
end
