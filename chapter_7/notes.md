### Working with mix

```bash
mix help
mix new todo
iex -S mix
mix compile
mix test
```

- https://hexdocs.pm/mix/Mix.html
- https://elixir-lang.org/getting-started/mix-otp/introduction-to-mix.html

### ExUnit

- https://hexdocs.pm/ex_unit/ExUnit.html
- https://hexdocs.pm/mix/Mix.Tasks.Test.html

### Encoding erlang terms

```elixir
> map = %{a: [1, 23, 4], b: 42, c: "42"}
> binary = :erlang.term_to_binary(map)
<<131, 116, 0, 0, 0, 3, 100, 0, 1, 97, 107, 0, 3, 1, 23, 4, 100, 0, 1, 98, 97,
  42, 100, 0, 1, 99, 109, 0, 0, 0, 2, 52, 50>>
> term = :erlang.binary_to_term(binary)
%{a: [1, 23, 4], b: 42, c: "42"}
```

- `:erlang.term_to_binary/1`
- `:erlang.binary_to_term/1`

### Worker pools and Databases

- https://github.com/devinus/poolboy
- https://github.com/elixir-ecto/ecto
