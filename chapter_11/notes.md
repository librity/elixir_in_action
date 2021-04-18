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
- http://erlang.org/doc

### `Poolboy` lib

```elixir
self() |> Process.info()
Process.get()
Process.list()
```

- https://github.com/devinus/poolboy
- https://hexdocs.pm/elixir/Version.html#module-requirements
- https://hex.pm/
- https://hexdocs.pm/mix/Mix.Tasks.Deps.html

### OTP `observer`

```elixir
Todo.Cache.Client.server_process("Bob")
Todo.Cache.Client.server_process("Alice")
:observer.start()
```

### `Cowboy` & `Plug`

```bash
wrk -t12 -c400 -d30s "http://localhost:5454/add_entry?list=bob&date=2018-12-19&title=Dentist"
wrk -t12 -c400 -d30s "http://localhost:5454/entries?list=bob&date=2018-12-19"
```

- https://github.com/ninenines/cowboy
- https://github.com/elixir-plug/plug
- https://github.com/wg/wrk
- https://github.com/elixir-lang/gen_stage

### Mix environments

```bash
MIX_ENV=prod mix compile
MIX_ENV=prod iex -S mix
mix test
hexdump -C _build/prod/lib/todo/ebin/Elixir.Todo.Database.beam | less
```

```elixir
System.get_env()
System.get_env("MIX_ENV")

Mix.env()

Application.get_env(:todo, :http_port)
Application.fetch_env!(:todo, :http_port)
```

###

```elixir

```
