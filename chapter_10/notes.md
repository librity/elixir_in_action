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
- https://github.com/quantum-elixir/quantum-core

### Agents

```elixir
{:ok, pid} = Agent.start_link(fn -> %{name: "Camilla Rhodes", age: 20} end)
Agent.get(pid, fn state -> state.name end)
Agent.update(pid, fn state -> %{state | age: state.age + 1} end)
Agent.cast(pid, fn state -> %{state | age: state.age + 1} end)
Agent.get(pid, fn state -> state end)

{:ok, counter} = Agent.start_link(fn -> 0 end)
spawn(fn -> Agent.update(counter, fn count -> count + 1 end) end)
spawn(fn -> Agent.cast(counter, fn count -> count + 1 end) end)
Agent.get(counter, fn count -> count end)
```

- https://hexdocs.pm/elixir/Agent.html

### Erlang Term Storage tables

```elixir
default_options = [
  :set,
  :protected,
  {:keypos, 1},
  {:heir, :none},
  {:write_concurrency, false},
  {:read_concurrency, false},
  {:decentralized_counters, false}
]

table = :ets.new(:my_table, default_options)
:ets.insert_new(table, {:garmon, :bozia})
:ets.insert(table, {:fire, :walk})
:ets.insert(table, {:fire, :with})
:ets.insert(table, {:fire, :me})
:ets.lookup(table, :fire)
:ets.lookup(table, :garmon)

another_table = :ets.new(:my_table, default_options)
:ets.insert_new(another_table, {:garmon, :bozia})
:ets.lookup(table, :garmon)
:ets.lookup(another_table, :garmon)

:ets.tab2list(table)

:ets.update_element(table, :garmon, {0, :green_formica})
:ets.lookup(table, :garmon)

:ets.delete(table, :garmon)
:ets.lookup(table, :garmon)

:ets.new(:my_table, [:named_table])
:ets.new(:my_table, [:named_table])
:ets.all()
```

- `:ets.update_element/3`
- `:ets.update_counter/4`
- `:ets.delete/2`
- `:ets.first/1`
- `:ets.next/2`
- Traversals aren't performant: `:ets.tab2list/1`, `:ets.safe_fixtable/2`
- [`:set`, `:ordered_set`, `:bag`, `:duplicate_bag`]
- [`:public`, `:protected`, `:private`]
- http://erlang.org/doc/man/ets.html
- http://erlang.org/doc/man/ets.html#insert_new-2

### ETS match patterns

```elixir
todo_list = :ets.new(:todo_list, [:bag])
:ets.insert(todo_list, {~D[2020-07-10], "Shopping"})
:ets.insert(todo_list, {~D[2020-07-10], "Rock climbing"})
:ets.insert(todo_list, {~D[2020-09-22], "Shopping"})
:ets.lookup(todo_list, ~D[2020-07-10])
:ets.match_object(todo_list, {:_, "Shopping"})

:ets.match_object(todo_list, {:"$1", :_})
:ets.select(todo_list, [
  {
    {:"$1", :_},
    [],
    [:"$_"]
  }
])

:ets.match_object(todo_list, {:"$1", :_})
:ets.select(todo_list, [
  {
    {~D[2020-07-10], :_},
    [],
    [:"$_"]
  }
])

:ets.match_delete(todo_list, {:_, "Shopping"})
:ets.tab2list(todo_list)
```

- More efficient than traversals (doesn't copy the entire list)
- `:ets.match_object/2`
- `:ets.match_delete/2`
- `:ets.match/2`
- `:ets.select/2`
- http://erlang.org/doc/man/ets.html#select-2
- https://github.com/ericmj/ex2ms
- http://erlang.org/doc/apps/odbc/databases.html
- https://elixirschool.com/en/lessons/specifics/ets/

### Disk-based Erlang Term Storage (:dets) and Mnesia database

- http://erlang.org/doc/man/dets.html
- http://erlang.org/doc/apps/mnesia/users_guide.html

###

```elixir

```

###

```elixir

```
