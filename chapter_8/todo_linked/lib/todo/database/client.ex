defmodule Todo.Database.Client do
  alias Todo.Database.Worker.Client, as: WorkerClient

  def start do
    IO.puts("Starting todo database.")

    GenServer.start(Todo.Database, nil, name: __MODULE__)
  end

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

  defp choose_worker(key), do: GenServer.call(__MODULE__, {:choose_worker, key})
end
