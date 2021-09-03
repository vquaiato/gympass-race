require Race
require Formatter
require Parser

defmodule Run do
  def main(args), do: args |> parse_args |> process

  defp process([]), do: IO.puts("No file provided")

  defp process(options) do
    case Parser.parse_text_file(options[:file]) do
      {:ok, parsed_log} ->
        result = Race.race_result_from(parsed_log)

        result |> Formatter.print_result()
        best_lap = result |> Race.best_lap()

        Formatter.print_best_lap(best_lap)

      {:error, reason} ->
        IO.puts("Error: #{reason}")
    end
  end

  defp parse_args(args) do
    {options, _, _} = OptionParser.parse(args, switches: [file: :string])
    options
  end
end
