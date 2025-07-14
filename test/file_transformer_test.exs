defmodule FileTransformerTest do
  use ExUnit.Case
  alias FileTransformer
  alias Voter
  alias VoterAddress

  test "write_voters_to_avro writes all fields" do
    voters = [
      %Voter{
        last_name: "Smith",
        first_name: "John",
        middle_name: "A",
        suffix: "Jr",
        dob: "1980-01-01",
        registration_date: "2000-01-01",
        voter_status: "Active",
        sos_voter_id: "Smith_John_A",
        party_code: "D",
        district: "District 1",
        precinct: "A01",
        voter_history: "2024_primary"
      }
    ]
    path = "test_voters.avro"
    assert :ok == FileTransformer.write_voters_to_avro(voters, path)
    assert File.exists?(path)
    File.rm!(path)
  end

  test "write_voter_addresses_to_avro writes addresses" do
    addresses = [
      %VoterAddress{
        sos_voter_id: "Smith_John_A",
        street: "123 Main St",
        mailing: false,
        city: "Columbus",
        state: "OH",
        zip: "43215",
        country: "USA"
      }
    ]
    path = "test_addresses.avro"
    assert :ok == FileTransformer.write_voter_addresses_to_avro(addresses, path)
    assert File.exists?(path)
    File.rm!(path)
  end

  test "write_ohio_counties_to_avro writes counties" do
    counties = ["Franklin", "Cuyahoga"]
    path = "test_counties.avro"
    assert :ok == FileTransformer.write_ohio_counties_to_avro(counties, path)
    assert File.exists?(path)
    File.rm!(path)
  end
end
