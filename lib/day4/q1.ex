defmodule Day4.Q1 do
  @moduledoc """
  Documentation for Day 4 Q1.
  """

  @format_string "{YYYY}-{0M}-{0D} {h24}:{m}"

  @doc """
  Find the guard that has the most minutes asleep. Then find what minute that guard spends asleep the most.
  Return the ID of the guard you chose multiplied by the minute you chose.

  Assumptions:  1. The logs may be out of order
                2. Each time a guard begins a shift, it is a new day's shift
                3. Input logs are all correctly formatted
  ## Examples

      iex> Q1.run(["[1518-11-01 00:05] falls asleep","[1518-11-01 00:25] wakes up","[1518-11-01 00:30] falls asleep","[1518-11-01 00:55] wakes up","[1518-11-01 23:58] Guard #99 begins shift","[1518-11-02 00:40] falls asleep","[1518-11-02 00:50] wakes up","[1518-11-03 00:05] Guard #10 begins shift","[1518-11-03 00:24] falls asleep","[1518-11-03 00:29] wakes up","[1518-11-04 00:02] Guard #99 begins shift","[1518-11-04 00:36] falls asleep","[1518-11-04 00:46] wakes up","[1518-11-05 00:03] Guard #99 begins shift","[1518-11-05 00:45] falls asleep","[1518-11-05 00:55] wakes up","[1518-11-01 00:00] Guard #10 begins shift"])
      240

  """
  def run(input_stream) do
    minute_counts =
      Enum.sort(input_stream)
      |> Enum.map(&parse_log/1)
      |> process_logs()
      |> combine_logs()

    # get map with most individual minutes
    {id, minutes} = Enum.max_by(minute_counts, fn {id, map} -> Map.values(map) |> Enum.sum() end)
    # get most popular minute
    {minute, _count} = Enum.max_by(minutes, fn {_, count} -> count end)

    minute * id
  end

  def parse_log(log) do
    <<"[", date_time_string::binary-size(16), "] ", message::binary>> = log

    {minute, _} =
      Timex.parse!(date_time_string, @format_string) |> Timex.format!("{m}") |> Integer.parse()

    action =
      case(String.trim(message)) do
        "falls asleep" ->
          :falls_asleep

        "wakes up" ->
          :wakes_up

        begins ->
          {id, _} = String.split(begins) |> Enum.at(1) |> String.slice(1, 99) |> Integer.parse()
          {:begins_shift, id}
      end

    {action, minute}
  end

  @doc """
  takes in list of logs in the format {action, minute}
  (action can be {:begins_shift, id}, :falls_asleep or :wakes_up)
  returns list of processed logs in the format {id, minute_fell_asleep, minute_woke_up}

  Assumptions
  1. `wakes up` always has a `falls asleep` before it when sorted

  """
  def process_logs(logs) do
    {_, _, processed_logs} =
      Enum.reduce(logs, {0, 0, []}, fn el, acc ->
        {id, last_time, list} = acc

        case el do
          {{:begins_shift, i}, _} ->
            {i, :reset_time, list}

          {:falls_asleep, date_time} ->
            {id, date_time, list}

          {:wakes_up, date_time} ->
            new_el = {id, last_time, date_time}
            {id, :reset_time, list ++ [new_el]}
        end
      end)

    processed_logs
  end

  @doc """
  takes in list of logs in the format {id, minute_fell_asleep, minute_woke_up}
  returns map of ids to list of each minute asleep

  ## Examples

      iex> Q1.combine_logs([{45, 23, 26}, {23, 10, 12}, {45, 24, 27}])
      %{45 => %{23 => 1, 24 => 2, 25 => 2, 26 => 1}, 23 => %{10 => 1, 11 => 1}}

  """
  def combine_logs(logs) do
    logs
    |> Enum.reduce(%{}, fn el, acc ->
      {id, a, b} = el
      id_map = Map.get(acc, id, %{})

      id_map =
        Enum.reduce(Range.new(a, b - 1), id_map, fn minute, map ->
          Map.update(map, minute, 1, &Kernel.+(&1, 1))
        end)

      Map.put(acc, id, id_map)
    end)
  end
end
