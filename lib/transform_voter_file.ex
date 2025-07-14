defmodule TransformVoterFile do
  @moduledoc """
  TransformVoterFile

  This module provides utility functions for transforming and preparing Ohio voter data files.
  It includes helpers for string manipulation, file streaming, and stubbed HTTP download logic
  for acquiring voter data from the Ohio Secretary of State website. The main features are:

  - String cleaning and normalization (e.g., upcasing, stripping quotes)
  - Streaming and transforming input files for easier inspection
  - Downloading (stub) of voter data files from the official Ohio SOS site

  Intended for use in data ingestion and preprocessing pipelines prior to modeling, validation,
  or export to Avro or other formats.
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

  # Stub function to download voter files from the Ohio SOS website and write to a temp .csv file
  # Disabled for testability: HTTPoison is not available in this environment.
  # def download_voter_files do
  #   url = "https://www6.ohiosos.gov/ords/f?p=VOTERFTP:STWD:::#stwdVtrFiles"
  #   case HTTPoison.get(url) do
  #     {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
  #       IO.puts("Downloaded HTML from Ohio SOS voter files page. Length: #{String.length(body)} bytes.")
  #       temp_csv_path = "./test_data/downloaded_voters_temp.csv"
  #       File.write!(temp_csv_path, body)
  #       IO.puts("Wrote HTML response to #{temp_csv_path} (for demo; in production, parse and download actual CSV files)")
  #       {:ok, temp_csv_path}
  #     {:ok, %HTTPoison.Response{status_code: code}} ->
  #       IO.puts("Failed to download page. Status code: #{code}")
  #       {:error, code}
  #     {:error, reason} ->
  #       IO.puts("HTTP request failed: #{inspect(reason)}")
  #       {:error, reason}
  #   end
  # end
end
