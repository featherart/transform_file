defmodule PartyAffiliation do
  @moduledoc """
  Struct and lookup table for party affiliation, with helper to query by party code or name.
  """
  defstruct [
    :party_code,
    :party_name
  ]

  @party_lookup %{
    "D" => "Democratic",
    "R" => "Republican",
    "L" => "Libertarian",
    "G" => "Green",
    "I" => "Independent",
    "N" => "Nonpartisan",
    "U" => "Unaffiliated"
  }

  @doc """
  Returns the party name for a given code, or nil if not found.
  """
  def get_party_name(code) when is_binary(code), do: Map.get(@party_lookup, code)

  @doc """
  Returns the party code for a given name, or nil if not found.
  """
  def get_party_code(name) when is_binary(name) do
    Enum.find_value(@party_lookup, fn {code, n} -> if String.downcase(n) == String.downcase(name), do: code end)
  end

  @doc """
  Returns the full party lookup table.
  """
  def all, do: @party_lookup
end
