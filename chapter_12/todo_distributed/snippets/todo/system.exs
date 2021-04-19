Process.whereis(Todo.System) |> Supervisor.count_children()

bobs_list = Todo.Cache.Client.server_process("bobs_list")
Todo.Server.Client.add_entry(bobs_list, %{date: ~D[2018-12-19], title: "Dentist"})
Todo.Server.Client.all(bobs_list)
:erlang.system_info(:process_count)

# System (supervisor) should restart Cache process
cache_pid = Process.whereis(Todo.Cache)
Process.exit(cache_pid, :kill)
cache_pid = Process.whereis(Todo.Cache)
bobs_list = Todo.Cache.Client.server_process("bobs_list")
Todo.Server.Client.add_entry(bobs_list, %{date: ~D[2018-12-19], title: "Dentist"})
Todo.Server.Client.all(bobs_list)
:erlang.system_info(:process_count)

# Cache (supervisor) shouldn't restart todo server
bobs_list = Todo.Cache.Client.server_process("bobs_list")
Process.exit(bobs_list, :kill)
bobs_list = Todo.Cache.Client.server_process("bobs_list")
Todo.Server.Client.add_entry(bobs_list, %{date: ~D[2018-12-19], title: "Dentist"})
Todo.Server.Client.all(bobs_list)
:erlang.system_info(:process_count)

# Exceed default restart frequency
Todo.System.start_link()

for _ <- 1..4 do
  Process.exit(Process.whereis(Todo.Cache), :kill)
  Process.sleep(200)
end
