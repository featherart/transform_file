defmodule TransformVoterFile do
  @moduledoc """
  A module for data transformation utilities.
  """

  #  upcase a string
  def upcase_string(str) when is_binary(str) do
    String.upcase(str)
  end

  # Removes leading and trailing quotes from a string, and replaces double quotes inside
  defp strip_quotes(str) when is_binary(str) do
    str
    |> String.trim_leading("\"")
    |> String.trim_trailing("\"")
    |> String.replace(~r/"+/, "")
  end

   # Streams a file, transforms each line, and writes the result to a temp txt file for easier viewing
  def read_file_stream(input_path) when is_binary(input_path) do
    temp_path = "transformed_temp.txt"
    input_path
    |> File.stream!()
    |> IO.inspect() # For debugging, can be removed later
    |> Stream.map(&strip_quotes/1)
    |> Stream.into(File.stream!(temp_path))
    |> Stream.run()
    temp_path
  end

end
