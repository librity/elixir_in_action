defmodule Todo.Cache do
  use GenServer

  alias Todo.Server.Client, as: TodoListClient

  @impl GenServer
  def init(_), do: {:ok, %{}}

  @impl GenServer
  def handle_call({:server_process, todo_list_name}, _, todo_servers) do
    case Map.fetch(todo_servers, todo_list_name) do
      {:ok, todo_server} -> {:reply, todo_server, todo_servers}
      :error -> spawn_server(todo_servers, todo_list_name)
    end
  end

  defp spawn_server(todo_servers, todo_list_name) do
    {:ok, new_server} = TodoListClient.start()

    {:reply, new_server, Map.put(todo_servers, todo_list_name, new_server)}
  end
end
