defmodule Precinct do
  @moduledoc """
  Struct and lookup table for precincts, with helpers for code/name lookup.
  """
  defstruct [
    :name,
    :code
  ]

  # Example lookup table. Replace with real data as needed.
  @precinct_lookup %{
    "A01" => "Downtown Central",
    "B02" => "Northside Heights",
    "C03" => "Westfield Park"
    # ... add more precincts as needed
  }

  @doc """
  Returns the precinct name for a given code, or nil if not found.
  """
  def get_name(code) when is_binary(code), do: Map.get(@precinct_lookup, code)

  @doc """
  Returns the precinct code for a given name, or nil if not found.
  """
  def get_code(name) when is_binary(name) do
    Enum.find_value(@precinct_lookup, fn {code, n} -> if String.downcase(n) == String.downcase(name), do: code end)
  end

  @doc """
  Returns the full precinct lookup table.
  """
  def all, do: @precinct_lookup
end
