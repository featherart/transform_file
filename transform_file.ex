defmodule FileTransformer do
  # A module for transforming voter files and encoding them as JSON. Not what we want for the task at hand, but useful for other purposes.

   # Removes leading and trailing quotes from a string, and replaces double quotes inside
  defp strip_quotes(str) when is_binary(str) do
    str
    |> String.trim_leading("\"")
    |> String.trim_trailing("\"")
    |> String.replace(~r/"+/, "")
  end

  # Streams a file, transforms each line, collects to a list, encodes as JSON, and writes to a JSON file
  def stream_transform_to_json(input_path) when is_binary(input_path) do
    output_path = "transformed_temp.json"

    lines =
      input_path
      |> File.stream!()
      |> Stream.map(&strip_quotes/1)
      |> Enum.to_list()

    json = Jason.encode!(lines)
    File.write!(output_path, json)
    output_path
  end
end
