defmodule FileTransformer do
  @moduledoc """
  FileTransformer

  This module provides utilities for transforming voter-related data and encoding it as AVRO files.
  It includes generic and specialized functions to write lists of structs
  (such as voters, voter addresses, and Ohio counties) to Avro files using the AvroEx library.

  The module is designed to abstract Avro encoding logic for different data types, making it easy to
  serialize and export structured data for downstream processing or storage.
  """


  # Writes a list of structs to an Avro file using the provided schema and record mapping function
  def write_to_avro(data, file_path, record_schema, record_mapper) when is_list(data) and is_binary(file_path) and is_map(record_schema) and is_function(record_mapper, 1) do
    avro_records = Enum.map(data, record_mapper)
    array_schema = %{"type" => "array", "items" => record_schema}
    schema = AvroEx.Schema.Parser.parse!(array_schema)
    {:ok, avro_binary} = AvroEx.encode(schema, avro_records)
    File.write!(file_path, avro_binary)
    :ok
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
        %{"name" => "suffix", "type" => "string"},
        %{"name" => "dob", "type" => "string"},
        %{"name" => "registration_date", "type" => "string"},
        %{"name" => "voter_status", "type" => "string"},
        %{"name" => "sos_voter_id", "type" => "string"},
        %{"name" => "party_code", "type" => "string"},
        %{"name" => "district", "type" => ["null", "string"], "default" => nil},
        %{"name" => "precinct", "type" => ["null", "string"], "default" => nil},
        %{"name" => "voter_history", "type" => ["null", "string"], "default" => nil}
      ]
    }
    record_mapper = fn voter -> %{
      "last_name" => voter.last_name || "",
      "first_name" => voter.first_name || "",
      "middle_name" => voter.middle_name || "",
      "suffix" => voter.suffix || "",
      "dob" => voter.dob || "",
      "registration_date" => voter.registration_date || "",
      "voter_status" => voter.voter_status || "",
      "sos_voter_id" => voter.sos_voter_id || "",
      "party_code" => voter.party_code || "",
      "district" =>
        case voter.district do
          nil -> nil
          val when is_binary(val) -> val
          val -> inspect(val)
        end,
      "precinct" =>
        case voter.precinct do
          nil -> nil
          val when is_binary(val) -> val
          val -> inspect(val)
        end,
      "voter_history" =>
        case voter.voter_history do
          nil -> nil
          val when is_binary(val) -> val
          val -> inspect(val)
        end
    } end
    write_to_avro(voters, file_path, schema, record_mapper)
  end

  # Helper for VoterAddress
  def write_voter_addresses_to_avro(addresses, file_path) do
    schema = %{
      "type" => "record",
      "name" => "VoterAddress",
      "fields" => [
        %{"name" => "sos_voter_id", "type" => "string"},
        %{"name" => "street", "type" => "string"},
        %{"name" => "mailing", "type" => "boolean"},
        %{"name" => "city", "type" => "string"},
        %{"name" => "state", "type" => "string"},
        %{"name" => "zip", "type" => "string"},
        %{"name" => "country", "type" => "string"}
      ]
    }
    record_mapper = fn addr -> %{
      "sos_voter_id" => addr.sos_voter_id || "",
      "street" => addr.street || "",
      "mailing" => addr.mailing || false,
      "city" => addr.city || "",
      "state" => addr.state || "",
      "zip" => addr.zip || "",
      "country" => addr.country || ""
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
