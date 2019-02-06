defmodule Day1.Q2V2 do
  alias Day1.Q1

  @doc """
  Input: a sequence of changes in frequency, separated by \n or ,
  A value like +6 means the current frequency increases by 6
  A value like -3 means the current frequency decreases by 3.
  Find first repeating frequency
    
  ## Examples

      iex> Q2V2.run("+1, -1")
      [0, 1, -1]
      iex> Q2V2.run("+3, +3, +4, -2, -4")
      ["10 + 4n", "8 + 4n"]
      iex> Q2V2.run "-6, +3, +8, +5, -6"
      ["5 + 4n", "10 + 4n"]
      iex> Q2V2.run("+7, +7, -2, -7, -4")
      ["7 + 1n", "14 + 1n", "12 + 1n", "5 + 1n"]

  """
  def run(input) do
    list = Q1.create_list(input)

    find_repeating_frequency(list)
  end

  def find_repeating_frequency(list) do
    step = Enum.sum(list)
    one_pass = Enum.scan(list, &(&1 + &2))

    case step do
      0 ->
        [0] ++ list

      step ->
        sparse_list =
          for i <- one_pass, j <- one_pass do
            cond do
              i > j ->
                diff = abs(i - j)

                if rem(diff, step) == 0 do
                  "#{i} + #{step}n"
                else
                  nil
                end

              true ->
                nil
            end
          end

        sparse_list
        |> Stream.filter(fn x -> x != nil end)
        |> Enum.dedup()
    end
  end
end
