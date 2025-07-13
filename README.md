# VoterSchema

***Transform Voter Files: Parses a CSV of Ohio voters and pretty prints to a temporary text file for easier viewing***

#### To run file transform script from an interactive prompt:
```
mix deps.get
mix compile
iex -S mix
iex> c "transform_voter_file.ex", "."
iex> filepath = "./test_data/test1.txt"
iex> TransformVoterFile.read_file_stream(filepath)
```

##### New file will be named `transformed_temp.txt`
