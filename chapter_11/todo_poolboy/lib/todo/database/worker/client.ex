defmodule Todo.Database.Worker.Client do
  alias Todo.Database.Worker

  defdelegate start_link(db_folder), to: Worker

  def store(worker_pid, key, data), do: GenServer.cast(worker_pid, {:store, key, data})
  def get(worker_pid, key), do: GenServer.call(worker_pid, {:get, key})
end
