defmodule TransformFile do
  @moduledoc """
  A module for data transformation utilities.
  """

  # Example transformation function: upcase a string
  def upcase_string(str) when is_binary(str) do
    String.upcase(str)
  end

  # Opens a local file and returns its contents as a string
  def read_file(path) when is_binary(path) do
    File.read(path)
    |> case do
      {:ok, content} -> content
      {:error, reason} -> "Error reading file: #{reason}"
    end
  end
end
