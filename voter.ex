defmodule Voter do
  @moduledoc """
  Struct and helpers for voter data parsed from CSV.
  """
  defstruct [
    :last_name,
    :first_name,
    :middle_name,
    :suffix,
    :dob,
    :registration_date,
    :voter_status,
    :sos_voter_id,
    :party_code
  ]

  @doc """
  Parses a CSV line into a Voter struct.
  Assumes the CSV columns are:
    last_name, first_name, middle_name, suffix, dob, registration_date, voter_status, street, city, state, zip, party_code
  Adjust the order if your file is different.
  """
  def from_csv_line(line) do
    [last_name, first_name, middle_name, suffix, dob, registration_date, voter_status, street, city, state, zip, party_code] =
      line
      |> String.trim()
      |> String.split(",", trim: false)

    %__MODULE__{
      last_name: last_name,
      first_name: first_name,
      middle_name: middle_name,
      suffix: suffix,
      dob: dob,
      registration_date: registration_date,
      voter_status: voter_status,
      sos_voter_id: "#{last_name}_#{first_name}_#{middle_name}",
      party_code: party_code
    }
  end

  @doc """
  Returns the party name for a voter struct using PartyAffiliation lookup.
  """
  def party_name(%__MODULE__{party_code: code}) do
    PartyAffiliation.get_party_name(code)
  end
end
