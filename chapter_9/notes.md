### Registry module

```elixir
Registry.start_link(name: :my_registry, keys: :unique)

spawn(fn ->
  Registry.register(:my_registry, {:database_worker, 1}, "garmonbozia")

  receive do
    message -> IO.puts("got message: #{inspect(message)}")
  end
end)

[{db_worker_pid, value}] = Registry.lookup(:my_registry, {:database_worker, 1})
IO.puts(value)
send(db_worker_pid, "fire walk with me")
Process.sleep(200)
Registry.lookup(:my_registry, {:database_worker, 1})
```

- https://hexdocs.pm/elixir/master/Registry.html
- https://elixir-lang.org/getting-started/mix-otp/ets.html
- https://code.tutsplus.com/articles/ets-tables-in-elixir--cms-29526

### Via tuples

- `{:via, some_module, some_arg}`
- `{:via, Registry, {registry_name, process_key}}`

Module attributes:

- https://stackoverflow.com/questions/37713244/access-module-attributes-outside-the-module
- https://elixir-lang.org/getting-started/module-attributes.html

### OTP-compliant processes

- http://erlang.org/doc/design_principles/spec_proc.html#id80464

### Supervisor options

- `Supervisor.terminate_child/2`
- `GenServer.terminate/2`
- `shutdown:` [`5000`, `:infinity` `:brutal_kill`]
- `strategy:` [`:one_for_one`, `:one_for_all`, `:rest_for_one`]
- `restart:` [`:temporary`, `:transient`]

### Dynamic Supervior

- https://hexdocs.pm/elixir/DynamicSupervisor.html

###

```elixir

```
