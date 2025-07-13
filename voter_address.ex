defmodule VoterAddress do
  defstruct [
    :SOS_voter_id,
    :street,
    :city,
    :state,
    :zip
  ]

  def from_csv_line(line) do
    [sos_id, street, _empty2, city, state, zip] =
      line
      |> String.trim()
      |> String.split(",", trim: false)

    %__MODULE__{
      SOS_voter_id: sos_id,
      street: street,
      city: city,
      state: state,
      zip: zip
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

  # Writes a list of VoterAddress structs to an Avro file
  def write_to_avro(addresses, file_path) when is_list(addresses) and is_binary(file_path) do
    schema = %{
      "type" => "record",
      "name" => "VoterAddress",
      "fields" => [
        %{"name" => "SOS_voter_id", "type" => "string"},
        %{"name" => "street", "type" => "string"},
        %{"name" => "city", "type" => "string"},
        %{"name" => "state", "type" => "string"},
        %{"name" => "zip", "type" => "string"}
      ]
    }

    avro_records =
      Enum.map(addresses, fn addr ->
        %{
          "SOS_voter_id" => addr.SOS_voter_id || "",
          "street" => addr.street || "",
          "city" => addr.city || "",
          "state" => addr.state || "",
          "zip" => addr.zip || ""
        }
      end)

    {:ok, avro_binary} = AvroEx.encode(schema, avro_records)
    File.write!(file_path, avro_binary)
  end
end
