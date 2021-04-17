Todo.Cache.Client.server_process(:"Bob's list")
Todo.Cache.Client.server_process(:"Bob's list")
Todo.Cache.Client.server_process("Alice's list")

bobs_list = Todo.Cache.Client.server_process(:"Bob's list")
Todo.Server.Client.add_entry(bobs_list, %{date: ~D[2018-12-19], title: "Dentist"})
Todo.Server.Client.entries(bobs_list, ~D[2018-12-19])

alices_list = Todo.Cache.Client.server_process("Alice's list")
Todo.Server.Client.entries(alices_list, ~D[2018-12-19])

# Count processes
:erlang.system_info(:process_count)

Enum.each(1..100_000, fn index ->
  Todo.Cache.Client.server_process("to-do list #{index}")
end)

:erlang.system_info(:process_count)
