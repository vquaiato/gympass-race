defmodule GTime do
  @milliseconds 1000
  @minutes 60

  def to_milli(%{hour: h, minute: m, second: s, microsecond: {mi, _}}) do
    sec = @milliseconds
    min = @minutes * sec
    (h * @minutes * min) + (m * min) + (s * sec) + div(mi,@milliseconds)
  end

  def to_time(mill) when mill < @milliseconds, do: Time.from_iso8601!("00:00:00.#{mill}")
  def to_time(mill) do
    rem_mill = rem(mill, @milliseconds)
    total_seconds = div(mill, @milliseconds)
    minutes = div(total_seconds, @minutes)
    rem_seconds = rem(total_seconds, @minutes)
    {:ok, t} = Time.new(0, minutes, rem_seconds, {rem_mill * @milliseconds, 3})
    t
  end
end
