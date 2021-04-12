{:ok, cache} = Todo.Cache.Client.start()
bobs_list = Todo.Cache.Client.server_process(cache, "bobs_list")
Todo.Server.Client.add_entry(bobs_list, %{date: ~D[2018-12-19], title: "Dentist"})
