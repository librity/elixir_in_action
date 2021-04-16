defmodule Todo.Database do
  use GenServer

  alias Todo.Database.Worker.Client, as: WorkerClient

  @db_folder "./persist"
  @pool_size 3

  @impl GenServer
  def init(_) do
    File.mkdir_p!(@db_folder)

    {:ok, start_workers!()}
  end

  @impl GenServer
  def handle_call({:choose_worker, key}, _, workers) do
    index = :erlang.phash2(key, @pool_size)

    {:reply, Map.get(workers, index), workers}
  end

  def handle_call(_bad_request, _caller, workers), do: {:reply, :bad_request, workers}

  defp start_workers!() do
    for index <- 1..3, into: %{} do
      {:ok, pid} = WorkerClient.start(@db_folder)

      {index - 1, pid}
    end
  end
end
