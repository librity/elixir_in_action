defmodule MultiDict do
  def new, do: %{}
  def add(dict, key, value), do: Map.update(dict, key, [value], &[value | &1])
  def get(dict, key), do: Map.get(dict, key, [])
end

defmodule Todo do
  def new, do: MultiDict.new()
  def add_entry(todo_list, entry), do: MultiDict.add(todo_list, entry.date, entry)
  def entries(todo_list, date), do: MultiDict.get(todo_list, date)
end

todo_list = Todo.new()
todo_list = Todo.add_entry(todo_list, %{date: ~D[2018-12-19], title: "Dentist"})
todo_list = Todo.add_entry(todo_list, %{date: ~D[2018-12-20], title: "Shopping"})
todo_list = Todo.add_entry(todo_list, %{date: ~D[2018-12-19], title: "Movies"})

Todo.entries(todo_list, ~D[2018-12-19])
Todo.entries(todo_list, ~D[2018-12-18])
