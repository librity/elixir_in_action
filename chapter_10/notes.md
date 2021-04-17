### Awaited tasks

```elixir
long_job = fn ->
  Process.sleep(2000)
  :result
end

task = Task.async(long_job)
# Execute concurret code here
Process.sleep(3000)
Task.await(task)

# Timeout
task = Task.async(long_job)
Task.await(task, 200)
```

```elixir
run_query = fn query_def ->
  Process.sleep(2000)
  "#{query_def} result"
end

tasks = Enum.map(1..5, &Task.async(fn -> run_query.("query #{&1}") end))
Process.sleep(1000)
Enum.map(tasks, &Task.await/1)

1..5 |> Enum.map(&Task.async(fn -> run_query.("query #{&1}") end)) |> Enum.map(&Task.await/1)
```

```elixir
crash = fn query_def ->
  Process.sleep(2000)
  exit("bad")
end

tasks = Enum.map(1..5, &Task.async(fn -> crash.("query #{&1}") end))
Process.sleep(1000)
Enum.map(tasks, &Task.await/1)
```

- `Task.async_stream/3`
- https://hexdocs.pm/elixir/Task.html

### Non-awaited tasks

```elixir
Task.start_link(fn ->
  Process.sleep(1000)
  IO.puts("I'm in a task")
end)
```

- `Task.start_link/1`

###

```elixir

```
