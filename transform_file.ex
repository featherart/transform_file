defmodule FileTransformer do
  # A module for transforming voter files and encoding them as JSON. Not what we want for the task at hand, but useful for other purposes.

  # Writes a list of structs to an Avro file using the provided schema and record mapping function
  def write_to_avro(data, file_path, schema, record_mapper) when is_list(data) and is_binary(file_path) and is_map(schema) and is_function(record_mapper, 1) do
    avro_records = Enum.map(data, record_mapper)
    {:ok, avro_binary} = AvroEx.encode(schema, avro_records)
    File.write!(file_path, avro_binary)
  end

  # Helper for Voter
  def write_voters_to_avro(voters, file_path) do
    schema = %{
      "type" => "record",
      "name" => "Voter",
      "fields" => [
        %{"name" => "last_name", "type" => "string"},
        %{"name" => "first_name", "type" => "string"},
        %{"name" => "middle_name", "type" => "string"},
        %{"name" => "sos_voter_id", "type" => "string"}
      ]
    }
    record_mapper = fn voter -> %{
      "last_name" => voter.last_name || "",
      "first_name" => voter.first_name || "",
      "middle_name" => voter.middle_name || "",
      "sos_voter_id" => voter.sos_voter_id || ""
    } end
    write_to_avro(voters, file_path, schema, record_mapper)
  end

  # Helper for VoterAddress
  def write_voter_addresses_to_avro(addresses, file_path) do
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
    record_mapper = fn addr -> %{
      "SOS_voter_id" => addr.SOS_voter_id || "",
      "street" => addr.street || "",
      "city" => addr.city || "",
      "state" => addr.state || "",
      "zip" => addr.zip || ""
    } end
    write_to_avro(addresses, file_path, schema, record_mapper)
  end

  # Helper for OhioCounty
  def write_ohio_counties_to_avro(counties, file_path) do
    schema = %{
      "type" => "record",
      "name" => "OhioCounty",
      "fields" => [
        %{"name" => "county", "type" => "string"}
      ]
    }
    record_mapper = fn county -> %{ "county" => county } end
    write_to_avro(counties, file_path, schema, record_mapper)
  end
end
