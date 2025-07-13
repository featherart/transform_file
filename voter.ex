defmodule Voter do
  @moduledoc """
  Struct and helpers for voter data parsed from CSV.
  """
  defstruct [
    :last_name,
    :first_name,
    :middle_name,
    :sos_voter_id
  ]

  @doc """
  Parses a CSV line into a Voter struct.
  Assumes the CSV columns are:
    last_name, first_name, middle_name, street, city, state, zip
  Adjust the order if your file is different.
  """
  def from_csv_line(line) do
    [last_name, first_name, middle_name, street, city, state, zip] =
      line
      |> String.trim()
      |> String.split(",", trim: false)

    %__MODULE__{
      last_name: last_name,
      first_name: first_name,
      middle_name: middle_name,
      sos_voter_id: "#{last_name}_#{first_name}_#{middle_name}",
    }
  end
end
