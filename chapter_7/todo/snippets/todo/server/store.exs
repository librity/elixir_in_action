Todo.Server.Store.start()
Todo.Server.Store.add_entry(%{date: ~D[2018-12-19], title: "Dentist"})
Todo.Server.Store.entries(~D[2018-12-19])

Todo.Server.Store.start()
Todo.Server.Store.add_entry(%{date: ~D[2018-12-19], title: "Dentist"})
Todo.Server.Store.add_entry(%{date: ~D[2018-12-20], title: "Shopping"})
Todo.Server.Store.add_entry(%{date: ~D[2018-12-19], title: "Movies"})
Todo.Server.Store.all()
Todo.Server.Store.by_date(~D[2018-12-19])

Todo.Server.Store.by_date(~D[2018-12-19])
Todo.Server.Store.by_date(~D[2018-12-18])

Todo.Server.Store.by_title("Movies")

Todo.Server.Store.by_id(2)

Todo.Server.Store.update_entry(1, &Map.put(&1, :date, ~D[2018-12-20]))
Todo.Server.Store.update_entry(1, &Map.put(&1, :title, "Zoo"))
Todo.Server.Store.update_entry(8, &Map.put(&1, :title, "Zoo"))
Todo.Server.Store.all()

Todo.Server.Store.update_entry(Todo.Entry.new(1, ~D[2021-12-20], "Rock climbing"))
Todo.Server.Store.update_entry(Todo.Entry.new(8, ~D[2021-12-20], "Rock climbing"))
Todo.Server.Store.all()

Todo.Server.Store.delete_entry(1)
Todo.Server.Store.delete_entry(8)
Todo.Server.Store.all()
