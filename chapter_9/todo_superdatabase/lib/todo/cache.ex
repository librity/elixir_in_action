defmodule Todo.Cache do
  use GenServer

  alias Todo.Server.Client, as: ServerClient

  def start_link(_) do
    IO.puts("Starting Todo.Cache")

    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl GenServer
  def init(_), do: {:ok, %{}}

  @impl GenServer
  def handle_call({:server_process, list_name}, _, todo_servers) do
    case Map.fetch(todo_servers, list_name) do
      {:ok, todo_server} -> {:reply, todo_server, todo_servers}
      :error -> spawn_server(todo_servers, list_name)
    end
  end

  def handle_call(_bad_request, _caller, todo_servers), do: {:reply, :bad_request, todo_servers}

  defp spawn_server(todo_servers, list_name) do
    {:ok, new_server} = ServerClient.start_link(list_name)

    {:reply, new_server, Map.put(todo_servers, list_name, new_server)}
  end
end
