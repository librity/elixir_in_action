defmodule Todo.Database do
  alias Todo.Database.Worker
  alias Todo.Database.Worker.Client, as: WorkerClient

  @db_folder "./persist"
  @pool_size 3

  def start_link do
    IO.puts("Starting todo database.")
    File.mkdir_p!(@db_folder)

    workers = Enum.map(1..@pool_size, &generate_worker_spec/1)
    Supervisor.start_link(workers, strategy: :one_for_one)
  end

  defp generate_worker_spec(worker_id) do
    {Worker, {@db_folder, worker_id}}
    |> Supervisor.child_spec(id: worker_id)
  end

  def child_spec(_),
    do: %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []},
      type: :supervisor
    }

  def choose_worker(key), do: :erlang.phash2(key, @pool_size) + 1
end
