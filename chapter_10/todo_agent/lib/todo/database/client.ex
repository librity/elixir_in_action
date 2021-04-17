defmodule Todo.Database.Client do
  alias Todo.Database
  alias Todo.Database.Worker.Client, as: WorkerClient

  defdelegate start_link, to: Database

  def store(key, data) do
    key
    |> Database.choose_worker()
    |> WorkerClient.store(key, data)
  end

  def get(key) do
    key
    |> Database.choose_worker()
    |> WorkerClient.get(key)
  end
end
