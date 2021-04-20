# elixir --sname terminator@localhost stop_node.exs
target_node = :todo_system@localhost

if Node.connect(target_node) == true do
  :rpc.call(target_node, System, :stop, [])
  IO.puts("Node #{target_node} terminated")
else
  IO.puts("Can't connect to node #{target_node}")
end
