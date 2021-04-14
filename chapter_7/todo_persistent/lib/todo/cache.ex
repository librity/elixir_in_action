defmodule Todo.Cache do
  use GenServer

  alias Todo.Server.Client, as: TodoListClient
  alias Todo.Database.Client, as: DatabaseClient

  @impl GenServer
  def init(_) do
    DatabaseClient.start()

    {:ok, %{}}
  end

  @impl GenServer
  def handle_call({:server_process, list_name}, _, todo_servers) do
    case Map.fetch(todo_servers, list_name) do
      {:ok, todo_server} -> {:reply, todo_server, todo_servers}
      :error -> spawn_server(todo_servers, list_name)
    end
  end

  defp spawn_server(todo_servers, list_name) do
    {:ok, new_server} = TodoListClient.start(list_name)

    {:reply, new_server, Map.put(todo_servers, list_name, new_server)}
  end
end
