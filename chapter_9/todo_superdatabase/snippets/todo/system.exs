{:ok, supervisor_pid} = Todo.System.start_link()
Supervisor.count_children(supervisor_pid)

bobs_list = Todo.Cache.Client.server_process("bobs_list")
Todo.Server.Client.add_entry(bobs_list, %{date: ~D[2018-12-19], title: "Dentist"})
Todo.Server.Client.entries(bobs_list, ~D[2018-12-19])
Todo.Server.Client.all(bobs_list)
:erlang.system_info(:process_count)

# Killing should restart everything
cache_pid = Process.whereis(Todo.Cache)
Process.exit(cache_pid, :kill)
cache_pid = Process.whereis(Todo.Cache)
bobs_list = Todo.Cache.Client.server_process("bobs_list")
Todo.Server.Client.add_entry(bobs_list, %{date: ~D[2018-12-19], title: "Dentist"})
Todo.Server.Client.entries(bobs_list, ~D[2018-12-19])
Todo.Server.Client.all(bobs_list)
:erlang.system_info(:process_count)

# Exceed default restart frequency
Todo.System.start_link()

for _ <- 1..4 do
  Process.exit(Process.whereis(Todo.Cache), :kill)
  Process.sleep(200)
end
