defmodule TestApp.GroupFixtures do
  @doc """
  Generate groups.
  """
  def group_fixtures() do
    [
      {"AE Group 1", "UAE", 10},
      {"AE Group 2", "UAE", 30},
      {"AE Group 3", "UAE", 35},
      {"AE Group 4", "UAE", 50},
      {"UK Group 1", "UK", 8},
      {"UK Group 2", "UK", 30},
      {"UK Group 3", "UK", 38},
      {"UK Group 4", "UK", 52}
    ]
    |> Enum.each(fn {name, region, score} ->
      TestApp.Groups.create_group(%{name: name, region: region, score: score})
    end)
  end
end
