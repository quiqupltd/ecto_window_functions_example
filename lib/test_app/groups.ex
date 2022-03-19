defmodule TestApp.Groups do
  import Ecto.Query

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
    query =
      from(g in Group)
      |> filter_region(region)
      |> add_rank(region)
      |> search(search)

    query |> Repo.all()
  end

  defp filter_region(query, nil), do: query

  defp filter_region(query, region) do
    from(g in query, where: g.region == ^region)
  end

  defp add_rank(query, nil) do
    from(g in query,
      windows: [p: [partition_by: nil, order_by: [desc: g.score]]],
      select_merge: %{group_rank: row_number() |> over(:p)}
    )
  end

  defp add_rank(query, _region) do
    from(g in query,
      windows: [p: [partition_by: g.region, order_by: [desc: g.score]]],
      select_merge: %{group_rank: row_number() |> over(:p)}
    )
  end

  defp search(query, nil), do: query

  defp search(query, search) do
    from(g in subquery(query), where: ilike(g.name, ^"%#{search}%"))
  end
end
