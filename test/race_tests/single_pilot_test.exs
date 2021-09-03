defmodule SinglePilotTest do
  use ExUnit.Case
  doctest Race

  test "one lap" do
    line =
      "23:49:08.277      038 – F.MASSA                           1    1:02.852                        44,275"
    {:ok, log} = Parser.parse_text_message(line)
    [result | _t] = Race.race_result_from(log)

    assert %{
      avg_lap_speed: 44.275,
      best_lap: ~T[00:01:02.852],
      laps: 1,
      pilot: "038 – F.MASSA",
      plus_time: ~T[00:00:00.0],
      position: 1,
      total_time: ~T[00:01:02.852]
    } = result
  end

  test "two laps" do
    line =
      "23:50:08.277      038 – F.MASSA                           1    1:00.000                        50,000
      23:52:08.277      038 – F.MASSA                           2    2:00.000                        100,000"
    {:ok, log} = Parser.parse_text_message(line)
    [result | _t] = Race.race_result_from(log)

    assert %{
      position: 1,
      pilot: "038 – F.MASSA",
      laps: 2,
      avg_lap_speed: 75.000,
      best_lap: ~T[00:01:00.000],
      plus_time: ~T[00:00:00.0],
      total_time: ~T[00:03:00.000]
    } = result
  end
end
