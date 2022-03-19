# Ecto Subquery and Window Example

A small example on how you can use ecto with subquery and window functions, this is the starting poing in case you want to follow along with the [medium post](https://medium.com/@dannyhawkins/ranked-data-with-ecto-window-queries-be4c169b9f86), if you want to skip straight to the solution, you can checkout the `solution` branch

## Getting started

Install the deps

```
mix do deps.get, deps.compile
```

I've included a docker compose for postgres that is preconfigured with the matching database values

```
docker-compose up -d
```

Make sure database exists

```
mix ecto.create
```

## Brief

I have a set of data where there is a scoring element and a grouping element, for example:

| Name       | Region | Score |
| ---------- | ------ | ----- |
| AE Group 1 | UAE    | 10    |
| AE Group 2 | UAE    | 30    |
| AE Group 3 | UAE    | 35    |
| AE Group 4 | UAE    | 50    |
| UK Group 1 | UK     | 8     |
| UK Group 2 | UK     | 30    |
| UK Group 3 | UK     | 38    |
| UK Group 4 | UK     | 52    |

When presenting this data, I also want to be able to show a rank element, and depending on the filter I want to be able to show that position within the context, for example when looking at all results:

| Rank | Name       | Region | Score |
| ---- | ---------- | ------ | ----- |
| 1    | UK Group 1 | UK     | 8     |
| 2    | AE Group 1 | UAE    | 10    |
| 3    | UK Group 2 | UK     | 30    |
| 4    | AE Group 2 | UAE    | 30    |
| 5    | AE Group 3 | UAE    | 35    |
| 6    | UK Group 3 | UK     | 38    |
| 7    | AE Group 4 | UAE    | 50    |
| 8    | UK Group 4 | UK     | 52    |

**When filtering for UK:**

| Rank | Name       | Region | Score |
| ---- | ---------- | ------ | ----- |
| 1    | UK Group 1 | UK     | 8     |
| 2    | UK Group 2 | UK     | 30    |
| 3    | UK Group 3 | UK     | 38    |
| 4    | UK Group 4 | UK     | 52    |

**When filtering for UAE:**

| Rank | Name       | Region | Score |
| ---- | ---------- | ------ | ----- |
| 1    | AE Group 1 | UAE    | 10    |
| 2    | AE Group 2 | UAE    | 30    |
| 3    | AE Group 3 | UAE    | 35    |
| 4    | AE Group 4 | UAE    | 50    |

Finally when searching a name, I want to be able to show the position based on the original pre-searched results

**Filter: "UAE", Search: "AE Group 4"**

| Rank | Name       | Region | Score |
| ---- | ---------- | ------ | ----- |
| 4    | AE Group 4 | UAE    | 50    |

**Filter: "UK", Search: "UK Group 2"**

| Rank | Name       | Region | Score |
| ---- | ---------- | ------ | ----- |
| 2    | UK Group 2 | UK     | 30    |

**Filter: "All", Search: "UK Group 2"**

| Rank | Name       | Region | Score |
| ---- | ---------- | ------ | ----- |
| 3    | UK Group 2 | UK     | 30    |

## Solution

In order to avoid having a position column in the database, and ensure that it always up to-date, we can create a virtual position field with the use of [window functions](https://hexdocs.pm/ecto/Ecto.Query.WindowAPI.html) and we can search that data while keeping the original window results intact by using a [subquery](https://hexdocs.pm/ecto/Ecto.Query.html#subquery/2)
