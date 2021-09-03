defmodule Parser do
  @moduledoc """
  Documentation for Parser.
  """

  def parse_text_file(file_name) do
    case File.read(file_name) do
      {:ok, content} -> parse_text_message(content)
      {:error, reason} -> IO.puts("Error: #{reason}")
    end
  end

  def parse_text_message(race_log) do
    case String.trim(race_log) do
      "" ->
        {:error, :empty_log}

      trimmed ->
        parsed =
          String.replace(trimmed, "\t", "  ")
          |> String.split("\n", trim: true)
          |> Enum.map(&line_to_map/1)

        {:ok, parsed}
    end
  end

  defp line_to_map(line) do
    [hora, piloto, volta, tempo, media] =
      String.split(line, "  ", trim: true) |> Enum.map(&String.trim/1)

    %{
      hora: hora |> Time.from_iso8601!(),
      piloto: piloto,
      volta: volta |> String.to_integer(),
      tempo: tempo |> String.pad_leading(12, "00:00:00:000") |> Time.from_iso8601!(),
      media: media |> String.replace(",", ".") |> String.to_float(),
      code: piloto |> String.slice(0..2)
    }
  end
end
