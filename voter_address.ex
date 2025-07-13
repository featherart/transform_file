defmodule VoterAddress do
  defstruct [
    :SOS_voter_id,
    :street,
    :mailing,
    :city,
    :state,
    :zip,
    :country
  ]

  def from_csv_line(line) do
    [sos_id, street, mailing, city, state, zip, country] =
      line
      |> String.trim()
      |> String.split(",", trim: false)

    %__MODULE__{
      SOS_voter_id: sos_id,
      street: street == "true",
      mailing: mailing == "true",
      city: city,
      state: state,
      zip: zip,
      country: country
    }
  end

  # Generates a hash for the address struct for efficient lookups
  def hash(%__MODULE__{street: street, city: city, state: state, zip: zip}) do
    :crypto.hash(:sha256, Enum.join([street, city, state, zip], ","))
    |> Base.encode16(case: :lower)
  end

  # Optionally, a function to build a map for fast address lookups
  def build_address_map(address_list) when is_list(address_list) do
    Enum.reduce(address_list, %{}, fn address, acc ->
      Map.put(acc, hash(address), address)
    end)
  end

  # Validates the address using an external service (e.g., USPS API)
  # This is a stub. In production, you would call the USPS API or another address validation service.
  # Returns {:ok, validated_address} or {:error, reason}
  def validate_with_usps(%__MODULE__{street: street, city: city, state: state, zip: zip} = address) do
    if street != nil and city != nil and state != nil and zip != nil do
      {:ok, address}
    else
      {:error, "Invalid address fields"}
    end
  end

  # Associates a list of voters with their addresses by SOS_voter_id
  # Returns a list of {voter, voter_address} tuples
  def join_voters_with_addresses(voters, voter_addresses) when is_list(voters) and is_list(voter_addresses) do
    address_map = Enum.reduce(voter_addresses, %{}, fn addr, acc ->
      Map.put(acc, addr.SOS_voter_id, addr)
    end)

    Enum.map(voters, fn voter ->
      address = Map.get(address_map, voter.sos_voter_id)
      {voter, address}
    end)
  end
end
