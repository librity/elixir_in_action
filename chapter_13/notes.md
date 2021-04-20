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

### Production releases w/ `Distillery`

```bash
MIX_ENV=prod elixir -S mix run --no-halt

mix release.init
MIX_ENV=prod mix release

# To list all commands:
_build/prod/rel/todo/bin/todo
# To start your system
_build/prod/rel/todo/bin/todo start
# To start your system with an iex shell
_build/prod/rel/todo/bin/todo start_iex
# To connect to it remotely
_build/prod/rel/todo/bin/todo remote
# To stop it gracefully (you may also send SIGINT/SIGTERM)
_build/prod/rel/todo/bin/todo stop

# All compiled dependencies
ls _build/prod/rel/todo/lib
```

```elixir
Application.app_dir(:todo, "priv")
:code.get_path()
```

- https://github.com/bitwalker/distillery
- https://hexdocs.pm/distillery/home.html
- http://erlang.org/doc/man/run_erl.html
- http://erlang.org/doc/design_principles/release_handling.html
- http://erlang.org/doc/design_principles/release_structure.html
- http://erlang.org/doc/man/systools.html
- http://erlang.org/doc/man/reltool.html

### Debugging == Logging

- https://elixir-lang.org/getting-started/debugging.html
- https://hexdocs.pm/logger/Logger.html
- https://hexdocs.pm/iex/IEx.html#pry/1

### Benchmarking & Profiling

```bash
mix profile.cprof
mix profile.eprof
mix profile.fprof
```

- http://erlang.org/doc/man/timer.html#tc-1
- https://github.com/alco/benchfella
- https://github.com/bencheeorg/benchee
- http://erlang.org/doc/efficiency_guide/profiling.html
- https://hexdocs.pm/mix/Mix.Tasks.Profile.Cprof.html
- https://hexdocs.pm/mix/Mix.Tasks.Profile.Eprof.html
- https://hexdocs.pm/mix/Mix.Tasks.Profile.Fprof.html

### System

- `:erlang.system_info/1`
- `:erlang.memory/0`
- `Process.list/0`
- `Process.info/1`

### Remote observer

```bash
_build/prod/rel/todo/bin/todo start
iex --hidden --name observer@127.0.0.1 --cookie todo
```

```elixir
iex(observer@127.0.0.1)1> :observer.start()
```

- https://github.com/shinyscorpion/wobserver

### Tracing processes

```elixir
:sys.trace(Todo.Cache.server_process("bob"), true)
:sys.trace(Todo.Cache.server_process("bob"), false)

# iex --name tracer@127.0.0.1 --cookie todo --hidden
iex(tracer@127.0.0.1)1> :dbg.tracer()
iex(tracer@127.0.0.1)2> :dbg.n(:'todo@127.0.0.1')
iex(tracer@127.0.0.1)3> :dbg.p(:all, [:call])
iex(tracer@127.0.0.1)4> :dbg.tp(Todo.Server, [])
iex(tracer@127.0.0.1)4> :dbg.stop_clear()
```

- `:sys.get_state/1`
- `:sys.replace_state/2`
- `:erlang.trace/3`
- http://erlang.org/doc/man/sys.html
- http://erlang.org/doc/man/dbg.html
- http://erlang.org/doc/man/erlang.html#trace-3
- https://github.com/ferd/recon
