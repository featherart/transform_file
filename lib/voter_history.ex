defmodule VoterHistory do
  @moduledoc """
  Struct and lookup tables for voter history, including recent elections and participation.
  """
  defstruct [
    :sos_voter_id,
    :elections # Map of election_id => true/false (voted or not)
  ]

  # Example lookup table for recent elections. Replace with real data as needed.
  @recent_elections [
    %{id: "2024_primary", name: "2024 Primary Election"},
    %{id: "2024_general", name: "2024 General Election"},
    %{id: "2023_general", name: "2023 General Election"},
    %{id: "2022_primary", name: "2022 Primary Election"},
    %{id: "2022_general", name: "2022 General Election"}
    # ...add more as needed
  ]

  @doc """
  Returns the list of recent elections (as maps with :id and :name).
  """
  def recent_elections, do: @recent_elections

  @doc """
  Returns the election name for a given election id.
  """
  def election_name(election_id) do
    Enum.find_value(@recent_elections, fn %{id: id, name: name} -> if id == election_id, do: name end)
  end

  @doc """
  Returns true if the voter participated in the given election.
  """
  def voted_in?(%__MODULE__{elections: elections}, election_id) do
    Map.get(elections, election_id, false)
  end
end
