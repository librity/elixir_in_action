defmodule Todo do
  def new, do: %{}
  def add_entry(todo_list, date, title), do: Map.update(todo_list, date, [title], &[title | &1])
  def entries(todo_list, date), do: Map.get(todo_list, date, [])
end

todo_list = Todo.new()
todo_list = Todo.add_entry(todo_list, ~D[2018-12-19], "Dentist")
todo_list = Todo.add_entry(todo_list, ~D[2018-12-20], "Shopping")
todo_list = Todo.add_entry(todo_list, ~D[2018-12-19], "Movies")

Todo.entries(todo_list, ~D[2018-12-19])
Todo.entries(todo_list, ~D[2018-12-18])
