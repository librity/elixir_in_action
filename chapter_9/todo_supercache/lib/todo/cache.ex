defmodule Todo.Cache do
  def start_link do
    IO.puts("Starting Todo.Cache")

    DynamicSupervisor.start_link(name: __MODULE__, strategy: :one_for_one)
  end

  def server_process(list_name) do
    case start_child(list_name) do
      {:ok, pid} -> pid
      {:error, {:already_started, pid}} -> pid
    end
  end

  defp start_child(list_name),
    do: DynamicSupervisor.start_child(__MODULE__, {Todo.Server, list_name})

  def child_spec(_),
    do: %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []},
      type: :supervisor
    }
end
