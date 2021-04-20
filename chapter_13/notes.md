### Running an Elixir application

```bash
mix run --no-halt
elixir -S mix run --no-halt

elixir --detached --sname todo_system@localhost -S mix run --no-halt
iex --sname debugger@localhost --remsh todo_system@localhost --hidden
```

```elixir
System.stop()
```

- https://hexdocs.pm/elixir/System.html#stop/1

### Escripts

```bash
mix escript.build
```

- https://hexdocs.pm/mix/Mix.Tasks.Escript.Build.html

### Production

```bash
MIX_ENV=prod elixir -S mix run --no-halt
```

```elixir

```

###

```elixir

```

###

```elixir

```
