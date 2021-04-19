### Starting a cluster

```bash
iex --sname node1@localhost
iex --sname node2@localhost
```

```elixir
> node()
node1@localhost
> iex(node2@localhost) |> Node.connect(:node1@localhost)
```

- https://en.wikipedia.org/wiki/Remote_procedure_call

###

```elixir

```

###

```elixir

```
