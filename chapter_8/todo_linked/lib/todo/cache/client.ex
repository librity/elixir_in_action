defmodule Todo.Cache.Client do
  def server_process(todo_list_name),
    do: GenServer.call(Todo.Cache, {:server_process, todo_list_name})
end
