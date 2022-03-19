defmodule TestApp.GroupsTest do
  use TestApp.DataCase, async: true

  alias TestApp.Groups

  import TestApp.GroupFixtures

  setup do
    group_fixtures()
  end

  defp assert_ranked(results, expected) do
    {:ok, groups} = results

    assert Enum.map(groups, fn group -> {group.rank, group.name, group.region, group.score} end) ==
             expected
  end

  describe "list_groups/2" do
    test "return the full list ranked" do
      assert_ranked(
        Groups.list_groups(),
        [
          {2, "AE Group 1", "UAE", 10},
          {3, "AE Group 2", "UAE", 30},
          {5, "AE Group 3", "UAE", 35},
          {7, "AE Group 4", "UAE", 50},
          {1, "UK Group 1", "UK", 8},
          {4, "UK Group 2", "UK", 30},
          {6, "UK Group 3", "UK", 38},
          {8, "UK Group 4", "UK", 52}
        ]
      )
    end

    test "return UAE region ranked" do
      assert_ranked(
        Groups.list_groups("UAE"),
        [
          {1, "AE Group 1", "UAE", 10},
          {2, "AE Group 2", "UAE", 30},
          {3, "AE Group 3", "UAE", 35},
          {4, "AE Group 4", "UAE", 50}
        ]
      )
    end

    test "return UK region ranked" do
      assert_ranked(
        Groups.list_groups("UK"),
        [
          {1, "UK Group 1", "UK", 8},
          {2, "UK Group 2", "UK", 30},
          {3, "UK Group 3", "UK", 38},
          {4, "UK Group 4", "UK", 52}
        ]
      )
    end

    test "return search result with correct rank for full list" do
      assert_ranked(
        Groups.list_groups(nil, "Group 2"),
        [
          {3, "UK Group 2", "UK", 30},
          {4, "AE Group 2", "UK", 30}
        ]
      )
    end

    test "return search result with correct rank for UAE" do
      assert_ranked(
        Groups.list_groups("UAE", "Group 4"),
        [
          {4, "AE Group 4", "UAE", 50}
        ]
      )
    end

    test "return search result with correct rank for UK" do
      assert_ranked(
        Groups.list_groups("UK", "Group 3"),
        [
          {3, "UK Group 3", "UK", 38}
        ]
      )
    end
  end
end
