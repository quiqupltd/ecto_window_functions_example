defmodule TestApp.Repo.Migrations.CreateGroups do
  use Ecto.Migration

  def change do
    create table(:groups) do
      add :name, :string, null: false
      add :region, :string, null: false
      add :score, :integer, null: false, default: 0
    end

    create index(:groups, :region)
  end
end
