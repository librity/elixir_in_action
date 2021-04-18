defmodule Todo.Database do
  alias Todo.Database.Worker
  alias Todo.Database.Worker.Client, as: WorkerClient

  @pool_size 3

  def child_spec(_) do
    IO.puts("Starting Todo.Database")
    db_folder = fetch_db_folder()
    File.mkdir_p!(db_folder)

    :poolboy.child_spec(
      __MODULE__,
      [
        name: {:local, __MODULE__},
        worker_module: Worker,
        size: @pool_size
      ],
      [db_folder]
    )
  end

  defp fetch_db_folder, do: Application.fetch_env!(:todo, :db_folder)

  def store(key, data) do
    :poolboy.transaction(
      __MODULE__,
      fn worker_pid -> WorkerClient.store(worker_pid, key, data) end
    )
  end

  def get(key) do
    :poolboy.transaction(
      __MODULE__,
      fn worker_pid -> WorkerClient.get(worker_pid, key) end
    )
  end
end
