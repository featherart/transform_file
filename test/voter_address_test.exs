defmodule VoterAddressTest do
  use ExUnit.Case
  alias VoterAddress

  describe "from_csv_line/1" do
    test "parses a CSV line into a VoterAddress struct" do
      line = "12345,123 Main St,true,Columbus,OH,43215,USA"
      addr = VoterAddress.from_csv_line(line)
      assert addr.sos_voter_id == "12345"
      assert addr.street == false # "123 Main St" == "true" is false
      assert addr.mailing == true
      assert addr.city == "Columbus"
      assert addr.state == "OH"
      assert addr.zip == "43215"
      assert addr.country == "USA"
    end
  end

  describe "hash/1" do
    test "generates a consistent hash for the address" do
      addr = %VoterAddress{
        sos_voter_id: "12345",
        street: "123 Main St",
        mailing: false,
        city: "Columbus",
        state: "OH",
        zip: "43215",
        country: "USA"
      }
      hash1 = VoterAddress.hash(addr)
      hash2 = VoterAddress.hash(addr)
      assert is_binary(hash1)
      assert hash1 == hash2
    end
  end

  describe "build_address_map/1" do
    test "builds a map of hashes to addresses" do
      addr1 = %VoterAddress{street: "123 Main St", city: "Columbus", state: "OH", zip: "43215"}
      addr2 = %VoterAddress{street: "456 Oak Ave", city: "Cleveland", state: "OH", zip: "44101"}
      map = VoterAddress.build_address_map([addr1, addr2])
      assert map[VoterAddress.hash(addr1)] == addr1
      assert map[VoterAddress.hash(addr2)] == addr2
    end
  end

  describe "validate_with_usps/1" do
    test "returns {:ok, address} for valid address" do
      addr = %VoterAddress{street: "123 Main St", city: "Columbus", state: "OH", zip: "43215"}
      assert {:ok, ^addr} = VoterAddress.validate_with_usps(addr)
    end

    test "returns {:error, reason} for invalid address" do
      addr = %VoterAddress{street: nil, city: "Columbus", state: "OH", zip: "43215"}
      assert {:error, _} = VoterAddress.validate_with_usps(addr)
    end
  end

  describe "join_voters_with_addresses/2" do
    test "joins voters with their addresses by sos_voter_id" do
      voters = [
        %{sos_voter_id: "1", name: "Alice"},
        %{sos_voter_id: "2", name: "Bob"}
      ]
      addresses = [
        %VoterAddress{sos_voter_id: "1", street: "A St"},
        %VoterAddress{sos_voter_id: "2", street: "B St"}
      ]
      result = VoterAddress.join_voters_with_addresses(voters, addresses)
      assert {voters |> Enum.at(0), addresses |> Enum.at(0)} in result
      assert {voters |> Enum.at(1), addresses |> Enum.at(1)} in result
    end
  end
end
