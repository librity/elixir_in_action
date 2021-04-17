### `Application`

```elixir
> Application.started_applications()
[
  {:hello_world, 'hello_world', '0.1.0'},
  {:logger, 'logger', '1.11.2'},
  {:mix, 'mix', '1.11.2'},
  {:iex, 'iex', '1.11.2'},
  {:elixir, 'elixir', '1.11.2'},
  {:compiler, 'ERTS  CXC 138 10', '7.6.6'},
  {:stdlib, 'ERTS  CXC 138 10', '3.14'},
  {:kernel, 'ERTS  CXC 138 10', '7.2'}
]
> Application.start(:hello_world)
{:error, {:already_started, :hello_world}}

Application.ensure_all_started(:hello_world)

Application.stop(:hello_world)
Application.started_applications()

System.stop()
Application.started_applications()
```

- `mix new hello_world --sup`
- `mix help compile.app`
- https://hexdocs.pm/logger/Logger.html
- https://hexdocs.pm/elixir/Application.html
- http://erlang.org/doc/apps/kernel/application.html

### Library applications

- Have no top-level supervisor.
- http://erlang.org/doc/apps/stdlib/index.html

###

```elixir

```
