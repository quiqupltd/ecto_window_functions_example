defmodule TestApp.Groups.Group do
  use Ecto.Schema
  import Ecto.Changeset

  schema "groups" do
    field(:name, :string, null: false)
    field(:region, :string, null: false)
    field(:score, :integer, null: false)

    # Has to be virtual!
    field(:rank, :integer, virtual: true)
  end

  def changeset(group, attrs) do
    group
    |> cast(attrs, [:name, :region, :score])
    |> validate_required([:name, :region, :score])
  end
end
