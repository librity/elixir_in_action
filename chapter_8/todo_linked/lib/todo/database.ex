defmodule Todo.Database do
  use GenServer

  alias Todo.Database.Worker.Client, as: WorkerClient

  @db_folder "./persist"
  @pool_size 3

  def start_link(_) do
    IO.puts("Starting todo database.")

    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl GenServer
  def init(_) do
    File.mkdir_p!(@db_folder)

    {:ok, start_workers!()}
  end

  @impl GenServer
  def handle_call({:choose_worker, key}, _caller, workers) do
    index = :erlang.phash2(key, @pool_size)

    {:reply, Map.get(workers, index), workers}
  end

  def handle_call(_bad_request, _caller, workers), do: {:reply, :bad_request, workers}

  defp start_workers!() do
    for index <- 1..@pool_size, into: %{} do
      zero_index = index - 1
      {:ok, pid} = WorkerClient.start_link({@db_folder, zero_index})

      {zero_index, pid}
    end
  end
end
