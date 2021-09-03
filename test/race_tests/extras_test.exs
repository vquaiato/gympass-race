defmodule ExtrasTest do
  use ExUnit.Case
  doctest Race

  describe "one lap each" do
    setup do
      line =
        "23:49:08.277      038 – F.MASSA                           1    1:02.852                        44,444
      23:49:09.277      039 – F.PASTA                           1    1:03.852                        42,222"

      {:ok, log} = Parser.parse_text_message(line)
      [first, last | _t] = r = Race.race_result_from(log)

      {:ok, first: first, last: last, r: r}
    end

    test(
      "can pull correctly the best lap of 1st",
      state,
      do: assert(%{best_lap: ~T[00:01:02.852]} = state[:first])
    )

    test(
      "can pull correctly the best lap of 2nd",
      state,
      do: assert(%{best_lap: ~T[00:01:03.852]} = state[:last])
    )

    test(
      "for the 1st place plus_time should be zeroed",
      state,
      do: assert(%{plus_time: ~T[00:00:00.0]} = state[:first])
    )

    test(
      "for the 2nd place plus_time should be +1 second",
      state,
      do: assert(%{plus_time: ~T[00:00:01.000]} = state[:last])
    )

    test(
      "for the 1st place avg_lap_speed should be same as the lap speed",
      state,
      do: assert(%{avg_lap_speed: 44.444} = state[:first])
    )

    test(
      "for the 2nd place avg_lap_speed should be same as the lap speed",
      state,
      do: assert(%{avg_lap_speed: 42.222} = state[:last])
    )

    test(
      "best lap should be the best_lap from the 1st place",
      state,
      do: assert(%{best_lap: ~T[00:01:02.852]} = Race.best_lap(state[:r]))
    )
  end

  describe "two laps each" do
    setup do
      line =
        "23:50:08.277      038 – F.MASSA                           1    1:00.000                        50,000
        23:52:08.277      038 – F.MASSA                           2    2:00.000                        100,000
        23:50:08.277      039 – F.PASTA                           1    0:59.000                        50,000
        23:52:08.277      039 – F.PASTA                           2    2:21.000                        30,000"

      {:ok, log} = Parser.parse_text_message(line)
      [first, last | _t] = r = Race.race_result_from(log)

      {:ok, first: first, last: last, r: r}
    end

    test(
      "can pull correctly the best lap of 1st",
      state,
      do: assert(%{best_lap: ~T[00:01:00.000]} = state[:first])
    )

    test(
      "can pull correctly the best lap of 2nd",
      state,
      do: assert(%{best_lap: ~T[00:00:59.000]} = state[:last])
    )

    test(
      "for the 1st place plus_time should be zeroed",
      state,
      do: assert(%{plus_time: ~T[00:00:00.0]} = state[:first])
    )

    test(
      "for the 2nd place plus_time should be +20 seconds",
      state,
      do: assert(%{plus_time: ~T[00:00:20.000]} = state[:last])
    )

    test(
      "for the 1st place avg_lap_speed should be same as the lap speed",
      state,
      do: assert(%{avg_lap_speed: 75.000} = state[:first])
    )

    test(
      "for the 2nd place avg_lap_speed should be same as the lap speed",
      state,
      do: assert(%{avg_lap_speed: 40.000} = state[:last])
    )

    test(
      "best lap should be the best_lap independently of the 1st place",
      state,
      do: assert(%{best_lap: ~T[00:00:59.000]} = Race.best_lap(state[:r]))
    )
  end
end
