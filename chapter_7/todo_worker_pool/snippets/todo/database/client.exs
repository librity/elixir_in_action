GenServer.start(Todo.Database, nil, name: Todo.Database.Client)
GenServer.cast(Todo.Database.Client, {:store, "dsad", "bananas"})
GenServer.call(Todo.Database.Client, {:get, "dsad"})

Todo.Database.Client.start()
Todo.Database.Client.get("dsad")
Todo.Database.Client.get("bobs_list")

{:ok, cache} = Todo.Cache.Client.start()
bobs_list = Todo.Cache.Client.server_process(cache, "bobs_list")
Todo.Server.Client.add_entry(bobs_list, %{date: ~D[2018-12-19], title: "Dentist"})
Todo.Server.Client.all(bobs_list)

{:ok, cache} = Todo.Cache.Client.start()
bobs_list = Todo.Cache.Client.server_process(cache, "bobs_list")
Todo.Server.Client.entries(bobs_list, ~D[2018-12-19])
