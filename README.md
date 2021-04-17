# Elixir in Action, 2nd Edition by by Saša Jurić

All my notes and solutions from
[the book](https://www.manning.com/books/elixir-in-action-second-edition).

- behavior > behaviour 😝

### `mix format` & `Path`

```elixir
Path.wildcard("./*.{ex,exs}")
Path.wildcard("./**/*.{ex,exs}") |> Enum.count()
Path.wildcard("{config,lib,test}/**/*.{ex,exs}")

Path.wildcard("chapter_*/**/*.{ex,exs}") |> Enum.count()
Path.wildcard("{chapter_*}/**/*.{ex,exs}") |> Enum.count()
```

- https://hexdocs.pm/mix/master/Mix.Tasks.Format.html
- https://hexdocs.pm/elixir/master/Path.html#wildcard/2
