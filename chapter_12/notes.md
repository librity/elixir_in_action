### Starting a cluster

```bash
iex --sname node1@localhost
iex --sname node2@localhost
iex --sname node3@localhost
```

```elixir
> node()
node1@localhost
> Node.connect(:node1@localhost)
true
> Node.list()
[:node1@localhost]
```

```elixir
> node()
node3@localhost
> Node.connect(:node2@localhost)
true
> Node.list()
[:node2@localhost, :node1@localhost]
> Node.list([:this, :visible])
[:node3@localhost, :node2@localhost, :node1@localhost]
```

- https://en.wikipedia.org/wiki/Remote_procedure_call
- `Node.monitor/1`
- `:net_kernel.monitor_nodes/1`
- https://hexdocs.pm/elixir/Node.html#monitor/2
- http://erlang.org/doc/man/net_kernel.html#monitor_nodes-1

### Communicating between nodes

```elixir
Node.spawn(
  :node2@localhost,
  fn -> IO.puts("Hello from #{node}!") end
)

caller = self()

Enum.each(1..10, fn number ->
  Node.spawn(
    :node2@localhost,
    fn -> send(caller, {:response, 10 * number}) end
  )
end)

flush()
```

- `Node.spawn/4`

### Local processes between nodes

```elixir
iex(node1@localhost)8> Process.register(self(), :shell)
true

iex(node2@localhost)3> Process.register(self(), :shell)
true

iex(node1@localhost)9> send(
    {:shell, :node2@localhost},
    "Hello from node1!"
)

iex(node2@localhost)4> flush()
"Hello from node1!"
```

- `GenServer.abcast/3`
- `GenServer.multi_call/4`

### Global process registration

```elixir
iex(node1@localhost)10> :global.register_name({:todo_list, "bob"}, self())
:yes
iex(node2@localhost)7> :global.register_name({:todo_list, "bob"}, self())
:no
iex(node2@localhost)8> :global.whereis_name({:todo_list, "bob"})
#PID<7954.90.0>
```

```elixir
GenServer.start_link(
  __MODULE__,
  :args,
  name: {:global, :some_global_alias}
)

GenServer.call(
  {:global, :some_global_alias},
  {:request, :args}
)
```

- http://erlang.org/doc/man/global.html
- https://hexdocs.pm/elixir/Kernel.html#node/1

### Process groups

```elixir
iex(node1@localhost)11> :pg2.start()
iex(node1@localhost)12> :pg2.create({:todo_list, "bob"})
:ok

iex(node2@localhost)9> :pg2.start()
iex(node2@localhost)10> :pg2.which_groups()
[todo_list: "bob"]
iex(node2@localhost)11> :pg2.join({:todo_list, "bob"}, self())
:ok

iex(node1@localhost)13> :pg2.get_members({:todo_list, "bob"})
[#PID<8531.90.0>]
iex(node1@localhost)14> :pg2.join({:todo_list, "bob"}, self())
:ok
iex(node1@localhost)15> :pg2.get_members({:todo_list, "bob"})
[#PID<8531.90.0>, #PID<0.90.0>]

iex(node2@localhost)12> :pg2.get_members({:todo_list, "bob"})
[#PID<0.90.0>, #PID<7954.90.0>]
```

- `:rpc.multi_call/4` (ModuleFunctionArguments + timeout)
- `:pg2.get_closest_pid/1`
- http://erlang.org/doc/man/pg2.html

### Links and monitors

```elixir
iex(node2@localhost)1> Node.connect(:node1@localhost)
iex(node2@localhost)2> :global.register_name({:todo_list, "bob"}, self())
iex(node1@localhost)1> Process.monitor(:global.whereis_name({:todo_list, "bob"}))
iex(node1@localhost)2> flush()
{:DOWN, #Reference<0.0.0.99>, :process, #PID<7954.90.0>, :noconnection}
```

### Other distribution services

```elixir
iex(node1@localhost)1> :rpc.call(:node2@localhost, Kernel, :abs, [-1])
1

iex(node1@localhost)1> :global.set_lock({:some_resource, self()})
true

iex(node2@localhost)1> :global.set_lock({:some_resource, self()})
# node2 hangs until node1 releases the lock
iex(node1@localhost)2> :global.del_lock({:some_resource, self()})

def process(large_data) do
  :global.trans(
    {:some_resource, self()},
    fn ->
      do_something_with(large_data)
    end
  )
end
```

- http://erlang.org/doc/man/net_adm.html
- http://erlang.org/doc/man/rpc.html
- http://erlang.org/doc/man/global.html#trans-2
- `:global.trans/2`

### Optimizing distributed process discovery

```elixir
# Works well as long as the number of nodes stay constant
def node_for_list(list_name) do
  all_sorted_nodes = Enum.sort(Node.list([:this, :visible]))

  node_index =
    :erlang.phash2(
      todo_list_name,
      length(all_sorted_nodes)
    )

  Enum.at(all_sorted_nodes, node_index)
end

:rpc.call(
  node_for_list(list_name),
  Todo.Cache,
  :server_process,
  [list_name]
)
```

- https://en.wikipedia.org/wiki/Consistent_hashing
- https://github.com/ostinelli/syn
- https://github.com/bitwalker/swarm

### Starting multiple todo instances

```bash
iex --sname node1@localhost -S mix
iex --erl "-todo port 5555" --sname node2@localhost -S mix
```

```elixir
Node.connect(:node1@localhost)
```

### Detecting partitions

```bash
iex --sname node1@localhost
iex --sname node2@localhost
iex --sname node3@localhost
```

```elixir
iex(node1@localhost)1> :net_kernel.monitor_nodes(true)
iex(node2@localhost)1> Node.connect(:node1@localhost)
iex(node3@localhost)1> Node.connect(:node1@localhost)

iex(node1@localhost)2> flush()
{:nodeup, :node2@localhost}
{:nodeup, :node3@localhost}

# Kill node1 and node2
iex(node1@localhost)3> flush()
{:nodedown, :node3@localhost}
{:nodedown, :node2@localhost}
```

- `:net_kernel.monitor_nodes/1`
- http://erlang.org/doc/man/net_kernel.html#monitor_nodes-1
- https://hexdocs.pm/elixir/Node.html#monitor/2

### Node names

```bash
iex --name node1@127.0.0.1
iex --name node2@some_host.some_domain
```

### Cookies

```elixir
iex(node1@localhost)1> Node.get_cookie()
:JHSKSHDYEJHDKEDKDIEN

iex(node1@localhost)1> Node.set_cookie(:some_cookie)
iex(node1@localhost)2> Node.get_cookie()
:some_cookie
```

```elixir
# iex --sname node1@localhost --cookie another_cookie
iex(node1@localhost)1> Node.get_cookie()
:another_cookie
```

### Hidden nodes

```bash
iex --sname node1@localhost
iex --hidden --sname node2@localhost
```

```elixir
iex(node2@localhost)2> Node.connect(:node1@localhost)
true

iex(node1@localhost)1> Node.list([:hidden])
[:node2@localhost]
iex(node1@localhost)2> Node.list([:connected])
[:node2@localhost]
iex(node1@localhost)3> Node.list([:visible])
[]
```

### Node listening ports

```bash
# Set the min and max port number
# that instance chooses to listen for node connections
iex \
--erl '-kernel inet_dist_listen_min 10000' \
--erl '-kernel inet_dist_listen_max 10100' \
-sname node2@localhost

epmd -names
```

```elixir
# Get all nodes and their respective listening ports
iex(node2@localhost)3> :net_adm.names()
{:ok, [{'node1', 43735}, {'node2', 10000}]}
```

- http://erlang.org/doc/apps/ssl/ssl_distribution.html
