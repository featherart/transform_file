defmodule District do
  @moduledoc """
  Struct for various district types that can be associated with a voter.
  """
  defstruct [
    :school,
    :county_court,
    :congressional,
    :court_of_appeals,
    :edu_service_center,
    :exempted_village_school,
    :library,
    :local_school,
    :municipal_court,
    :state_senate,
    :township
  ]

  # Example lookup table for district types. Replace with real data as needed.
  @district_lookup %{
    school: ["District 1", "District 2"],
    county_court: ["Court A", "Court B"],
    congressional: ["OH-1", "OH-2"],
    court_of_appeals: ["Appeals 1", "Appeals 2"],
    edu_service_center: ["ESC 1", "ESC 2"],
    exempted_village_school: ["Village 1", "Village 2"],
    library: ["Library 1", "Library 2"],
    local_school: ["Local 1", "Local 2"],
    municipal_court: ["Municipal 1", "Municipal 2"],
    state_senate: ["Senate 1", "Senate 2"],
    township: ["Township 1", "Township 2"]
  }

  @doc """
  Returns the list of possible values for a given district type (atom).
  """
  def get(type) when is_atom(type), do: Map.get(@district_lookup, type)

  @doc """
  Returns the full district lookup table.
  """
  def all, do: @district_lookup
end
