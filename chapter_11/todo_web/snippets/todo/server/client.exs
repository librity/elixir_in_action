{:ok, pid} = Todo.Server.Client.start_link("list1")
Todo.Server.Client.add_entry(pid, %{date: ~D[2018-12-19], title: "Dentist"})
Todo.Server.Client.entries(pid, ~D[2018-12-19])

{:ok, pid} = Todo.Server.Client.start_link("list2")
Todo.Server.Client.add_entry(pid, %{date: ~D[2018-12-19], title: "Dentist"})
Todo.Server.Client.add_entry(pid, %{date: ~D[2018-12-20], title: "Shopping"})
Todo.Server.Client.add_entry(pid, %{date: ~D[2018-12-19], title: "Movies"})
Todo.Server.Client.all(pid)
Todo.Server.Client.by_date(pid, ~D[2018-12-19])

Todo.Server.Client.by_date(pid, ~D[2018-12-19])
Todo.Server.Client.by_date(pid, ~D[2018-12-18])

Todo.Server.Client.by_title(pid, "Movies")

Todo.Server.Client.by_id(pid, 2)

Todo.Server.Client.update_entry(pid, 1, &Map.put(&1, :date, ~D[2018-12-20]))
Todo.Server.Client.update_entry(pid, 1, &Map.put(&1, :title, "Zoo"))
Todo.Server.Client.update_entry(pid, 8, &Map.put(&1, :title, "Zoo"))
Todo.Server.Client.all(pid)

Todo.Server.Client.update_entry(pid, Todo.Entry.new(1, ~D[2021-12-20], "Rock climbing"))
Todo.Server.Client.update_entry(pid, Todo.Entry.new(8, ~D[2021-12-20], "Rock climbing"))
Todo.Server.Client.all(pid)

Todo.Server.Client.delete_entry(pid, 1)
Todo.Server.Client.delete_entry(pid, 8)
Todo.Server.Client.all(pid)
