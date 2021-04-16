defmodule Todo.Database.Client do
  alias Todo.Database
  alias Todo.Database.Worker.Client, as: WorkerClient

  defdelegate start_link(params \\ nil), to: Database

  def store(key, data) do
    key
    |> choose_worker()
    |> WorkerClient.store(key, data)
  end

  def get(key) do
    key
    |> choose_worker()
    |> WorkerClient.get(key)
  end

  defp choose_worker(key), do: GenServer.call(Database, {:choose_worker, key})
end
