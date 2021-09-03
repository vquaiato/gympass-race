defmodule ParserTest do
  use ExUnit.Case
  doctest Parser

  test "empty race log returns {:error, :empty_log}" do
    assert {:error, :empty_log} = Parser.parse_text_message("")
  end

  test "whitespaces only race log returns {:error, :empty_log}" do
    assert {:error, :empty_log} = Parser.parse_text_message("      ")
  end

  test "one line log parses correct fields" do
    line =
      "23:49:08.277      038 – F.MASSA                           1    1:02.852                        44,275"

    {:ok, [race | _]} = Parser.parse_text_message(line)

    assert %{
             hora: ~T[23:49:08.277],
             piloto: "038 – F.MASSA",
             volta: 1,
             tempo: ~T[00:01:02.852],
             media: 44.275
           } = race
  end

  test "multi line log parses correct fields" do
    line =
      "23:49:12.667      023 – M.WEBBER                          1		1:04.414                        43,202
      23:49:30.976      015 – F.ALONSO                          1		1:18.456			35,47
      23:50:11.447      038 – F.MASSA                           2		1:03.170                        44,053"

    {:ok, parsed_race} = Parser.parse_text_message(line)

    assert [
             %{
               hora: ~T[23:49:12.667],
               piloto: "023 – M.WEBBER",
               volta: 1,
               tempo: ~T[00:01:04.414],
               media: 43.202
             },
             %{
               hora: ~T[23:49:30.976],
               piloto: "015 – F.ALONSO",
               volta: 1,
               tempo: ~T[00:01:18.456],
               media: 35.47
             },
             %{
               hora: ~T[23:50:11.447],
               piloto: "038 – F.MASSA",
               volta: 2,
               tempo: ~T[00:01:03.170],
               media: 44.053
             }
           ] = parsed_race
  end
end
