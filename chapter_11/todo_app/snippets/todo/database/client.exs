Todo.Database.Client.get("dsad")
Todo.Database.Client.get("bobs_list")

bobs_list = Todo.Cache.Client.server_process("bobs_list")
Todo.Server.Client.add_entry(bobs_list, %{date: ~D[2018-12-19], title: "Dentist"})
Todo.Server.Client.all(bobs_list)

bobs_list = Todo.Cache.Client.server_process("bobs_list")
Todo.Server.Client.entries(bobs_list, ~D[2018-12-19])
