### Error types

```elixir
# Errors
1 / 0
Module.nonexistent_function()
List.first({1, 2, 3})
raise("Something went wrong")
File.open!("nonexistent_file")

# Exits
spawn(fn ->
  exit("I'm done")
  IO.puts("This doesn't happen")
end)

# Throws
throw(:thrown_value)
```

- `errors`, `exits` and `throws`

### Handling errors

```elixir
try_helper = fn fun ->
  try do
    fun.()
    IO.puts("No error.")
  catch
    type, value ->
      IO.puts("Error\n  #{inspect(type)}\n  #{inspect(value)}")
  end
end

try_helper.(fn -> raise("Something went wrong") end)
try_helper.(fn -> :erlang.error("Something went really wrong") end)
try_helper.(fn -> throw("Catch!") end)
try_helper.(fn -> exit("I'm done") end)

result =
  try do
    throw("Thrown value")
  catch
    type, value -> {type, value}
  end

result

try do
  raise("Something went wrong")
catch
  _, _ -> IO.puts("Error caught")
after
  IO.puts("Cleanup code")
end
```

- https://hexdocs.pm/elixir/Kernel.html#defexception/1
- https://hexdocs.pm/elixir/Kernel.SpecialForms.html#try/1
- https://elixir-lang.org/getting-started/try-catch-and-rescue.html

### Errors & concurrency

```elixir
spawn(fn ->
  spawn(fn ->
    Process.sleep(1000)
    IO.puts("Process 2 finished")
  end)

  raise("Something went wrong!")
end)
```

### Linking processes

```elixir
spawn(fn ->
  Enum.each(2..5, fn number ->
    spawn_link(fn ->
      Process.sleep(1000)
      IO.puts("Process #{number} finished")
    end)
  end)

  raise("Something went wrong!")
end)

spawn(fn ->
  Enum.each(2..5, fn number ->
    spawn_link(fn ->
      Process.sleep(1000)
      IO.puts("Process #{number} finished")
    end)
  end)

  spawn_link(fn ->
    raise("Something went wrong!")
  end)
end)

spawn(fn ->
  spawn_link(fn ->
    spawn_link(fn ->
      spawn_link(fn ->
        spawn_link(fn ->
          raise("Something went wrong!")
        end)

        Process.sleep(1000)
        IO.puts("Process 4 finished")
      end)

      Process.sleep(1000)
      IO.puts("Process 3 finished")
    end)

    Process.sleep(1000)
    IO.puts("Process 2 finished")
  end)

  Process.sleep(1000)
  IO.puts("Process 1 finished")
end)
```

- `Process.link/1`
- `spawn_link/1`

### Linking processes (bidiretional)

```elixir
spawn(fn ->
  Process.flag(:trap_exit, true)

  spawn_link(fn -> raise("Something went wrong") end)

  receive do
    {:EXIT, _pid, _reason} = msg -> IO.inspect(msg)
  end
end)

spawn(fn ->
  Process.flag(:trap_exit, true)

  spawn_link(fn -> throw("Something went wrong") end)

  receive do
    {:EXIT, _pid, _reason} = msg -> IO.inspect(msg)
  end
end)

spawn(fn ->
  Process.flag(:trap_exit, true)

  spawn_link(fn -> exit("Something went wrong") end)

  receive do
    {:EXIT, _pid, _reason} = msg -> IO.inspect(msg)
  end
end)
```

### Monitors (unidirectional)

```elixir
target_pid = spawn(fn -> Process.sleep(1000) end)
Process.monitor(target_pid)

receive do
  msg -> IO.inspect(msg)
end
```

- `monitor_ref = Process.monitor(target_pid)`
- `Process.demonitor(monitor_ref)`

### Supervisors

```elixir
Supervisor.start_link(
  [%{id: Todo.Cache, start: {Todo.Cache, :start_link, [nil]}}],
  strategy: :one_for_one
)

Supervisor.start_link([{Todo.Cache, nil}], strategy: :one_for_one)
Supervisor.start_link([Todo.Cache], strategy: :one_for_one)
Todo.Cache.child_spec(nil)
```

- https://hexdocs.pm/elixir/Supervisor.html#module-child-specification
- https://hexdocs.pm/elixir/GenServer.html#module-use-genserver-and-callbacks

###

```elixir

```

###

```elixir

```

###

```elixir

```
