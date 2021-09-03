defmodule Formatter do
  def print_result(enum) do
    IO.puts("\n\n🏁 Gympass Kart Race 🏎 🏎 🏎\n")
    spacer_print("Position", 10)
    spacer_print("Pilot")
    spacer_print("Laps", 8)
    spacer_print("Time", 15)
    spacer_print("Best Lap", 15)
    spacer_print("Avg Lap Speed", 15)
    spacer_print("After 1st")
    IO.puts("")

    enum
    |> Enum.each(fn %{
                      position: pos,
                      laps: l,
                      total_time: t,
                      pilot: p,
                      best_lap: b,
                      plus_time: plus,
                      avg_lap_speed: s
                    } ->
      IO.write("#{spacer(Integer.to_string(pos), 10)}")
      IO.write("#{spacer(p)}#{spacer(Integer.to_string(l), 8)}")
      IO.write("#{spacer(Time.to_string(t), 15)}")
      IO.write("#{spacer(Time.to_string(b), 15)}")
      IO.write("#{spacer(Float.floor(s, 3) |> Float.to_string(), 15)}")
      IO.write("#{spacer(Time.to_string(plus))}")
      IO.write("\n")
    end)
  end

  def print_best_lap(%{pilot: p, best_lap: b}) do
    IO.puts("\n\n⏱ The best lap")
    spacer_print("Pilot")
    spacer_print("Time", 15)
    IO.puts("")

    IO.write("#{spacer(p)}")
    IO.write("#{spacer(Time.to_string(b), 15)}")
  end

  defp spacer(text, spaces \\ 23), do: String.pad_trailing(text, spaces)
  defp spacer_print(text, spaces \\ 23), do: IO.write(spacer(text, spaces))
end
