defmodule VoterSchemaTest do
  use ExUnit.Case
  doctest VoterSchema

  test "greets the world" do
    assert VoterSchema.hello() == :world
  end
end
