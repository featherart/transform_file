# VoterSchema

***Transform Voter Files: Parses a CSV of Ohio voters and pretty prints to a temporary text file for easier viewing***

## Installation

### To run file transform script from an interactive prompt:
```
mix compile
iex -S mix
iex> c "transform_voter_file.ex", "."
iex> filepath = "./test_data/test1.txt"
iex> TransformVoterFile.read_file_stream(filepath)
```

### New file will be named `transformed_temp.txt`

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `voter_schema` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:voter_schema, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/voter_schema>.

