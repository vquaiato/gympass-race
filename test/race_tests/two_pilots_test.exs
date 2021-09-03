defmodule TwoPilotsTest do
  use ExUnit.Case
  doctest Race

  describe "one lap each" do
    setup do
      line =
        "23:49:08.277      038 – F.MASSA                           1    1:02.852                        44,444
      23:49:09.277      039 – F.PASTA                           1    1:03.852                        42,222"

      {:ok, log} = Parser.parse_text_message(line)
      [first, last | _t] = Race.race_result_from(log)

      {:ok, first: first, last: last}
    end

    test "can pull correctly the 1st place", state do
      assert %{
               avg_lap_speed: 44.444,
               best_lap: ~T[00:01:02.852],
               laps: 1,
               pilot: "038 – F.MASSA",
               plus_time: ~T[00:00:00.0],
               position: 1,
               total_time: ~T[00:01:02.852]
             } = state[:first]
    end

    test "can pull correctly the plus time after 1st place", state do
      assert %{
               avg_lap_speed: 42.222,
               best_lap: ~T[00:01:03.852],
               laps: 1,
               pilot: "039 – F.PASTA",
               plus_time: ~T[00:00:01.000],
               position: 2,
               total_time: ~T[00:01:03.852]
             } = state[:last]
    end
  end

  describe "two laps each" do
    setup do
      line =
        "23:50:08.277      038 – F.MASSA                           1    1:00.000                        50,000
        23:52:08.277      038 – F.MASSA                           2    2:00.000                        100,000
        23:50:08.277      039 – F.PASTA                           1    1:10.000                        50,000
        23:52:08.277      039 – F.PASTA                           2    2:20.000                        30,000"

      {:ok, log} = Parser.parse_text_message(line)
      [first, last | _t] = Race.race_result_from(log)

      {:ok, first: first, last: last}
    end

    test "can pull correctly the 1st place", state do
      assert %{
               position: 1,
               pilot: "038 – F.MASSA",
               laps: 2,
               avg_lap_speed: 75.000,
               best_lap: ~T[00:01:00.000],
               plus_time: ~T[00:00:00.0],
               total_time: ~T[00:03:00.000]
             } = state[:first]
    end

    test "can pull correctly the plus time after 1st place", state do
      assert %{
               avg_lap_speed: 40.000,
               best_lap: ~T[00:01:10.000],
               laps: 2,
               pilot: "039 – F.PASTA",
               plus_time: ~T[00:00:30.000],
               position: 2,
               total_time: ~T[00:03:30.000]
             } = state[:last]
    end
  end
end
