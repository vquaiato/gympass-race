defmodule Race do
  @moduledoc """
  Documentation for Gympass.
  """

  @doc """
  Hello world.

  ## Examples

  """
  def race_result_from(race_log) do
    [%{total_time: fst_place_time} = first | others] =
      race_log
      |> group_by_pilot()
      |> calculate_race_time_by_pilot()
      |> set_position_by_race_time()
      |> create_final_result()

    [first | others]
    |> add_time_after_1st_place(fst_place_time)
  end

  def best_lap(race) do
    race
    |> Enum.sort(fn %{best_lap: t1}, %{best_lap: t2} ->
      GTime.to_milli(t1) < GTime.to_milli(t2)
    end)
    |> List.first()
  end

  defp group_by_pilot(enum), do: enum |> Enum.group_by(fn %{code: c} -> c end)

  defp calculate_race_time_by_pilot(enum),
    do:
      enum
      |> Enum.map(fn {_k, p} ->
        %{
          total: Enum.reduce(p, 0, fn %{tempo: t}, acc -> GTime.to_milli(t) + acc end),
          laps: p
        }
      end)

  defp set_position_by_race_time(enum),
    do: enum |> Enum.sort(fn %{total: t1}, %{total: t2} -> t1 < t2 end) |> Enum.with_index(1)

  defp create_final_result(enum) do
    sort_by_time = fn e ->
      e
      |> Enum.sort(fn %{tempo: t1}, %{tempo: t2} -> t1 < t2 end)
    end

    enum
    |> Enum.map(fn {%{laps: [%{piloto: p} | _t] = laps, total: t}, pos} ->
      %{tempo: best} = laps |> sort_by_time.() |> List.first()

      total_laps = Enum.count(laps)
      total_lap_speed = laps |> Enum.map(fn %{media: lap_speed} -> lap_speed end) |> Enum.sum()

      %{
        position: pos,
        laps: total_laps,
        total_time: GTime.to_time(t),
        pilot: p,
        best_lap: best,
        avg_lap_speed: total_lap_speed / total_laps
      }
    end)
  end

  defp add_time_after_1st_place(enum, fst_place_time),
    do:
      enum
      |> Enum.map(fn %{total_time: t} = x ->
        Map.put_new(x, :plus_time, GTime.to_time(Time.diff(t, fst_place_time, :millisecond)))
      end)
end
