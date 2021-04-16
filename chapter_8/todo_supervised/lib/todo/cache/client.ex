defmodule Todo.Cache.Client do
  def start, do: GenServer.start(Todo.Cache, nil)

  def server_process(pid, todo_list_name),
    do: GenServer.call(pid, {:server_process, todo_list_name})
end
