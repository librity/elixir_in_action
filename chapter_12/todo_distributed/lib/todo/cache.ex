defmodule Todo.Cache do
  alias Todo.Server
  alias Todo.Server.Client, as: ServerClient

  def start_link do
    IO.puts("Starting Todo.Cache")

    DynamicSupervisor.start_link(name: __MODULE__, strategy: :one_for_one)
  end

  def child_spec(_),
    do: %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []},
      type: :supervisor
    }

  def server_process(list_name), do: existing_process(list_name) || new_process(list_name)

  defp existing_process(list_name), do: ServerClient.where_is(list_name)

  defp new_process(list_name) do
    case start_child(list_name) do
      {:ok, pid} -> pid
      {:error, {:already_started, pid}} -> pid
    end
  end

  defp start_child(list_name),
    do: DynamicSupervisor.start_child(__MODULE__, {Server, list_name})
end
