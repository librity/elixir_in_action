defmodule Todo.Cache.Client do
  alias Todo.Cache

  defdelegate start_link(params \\ nil), to: Cache

  def server_process(todo_list_name),
    do: GenServer.call(Cache, {:server_process, todo_list_name})
end
