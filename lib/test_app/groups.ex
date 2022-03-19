defmodule TestApp.Groups do
  alias TestApp.Repo
  alias TestApp.Groups.Group

  @doc """
  Create a new group

  ## Examples

    iex> TestApp.Groups.create_group(%{name: "group1", region: "UAE", score: 10})
    {:ok, %TestApp.Groups.Group{name: "group1", region: "UAE", score: 10}
  """
  def create_group(attrs) do
    %Group{} |> Group.changeset(attrs) |> Repo.insert()
  end

  def list_groups(region \\ nil, search \\ nil) do
  end
end
