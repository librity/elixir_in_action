defmodule Todo.Database do
  alias Todo.Database.Worker
  alias Todo.Database.Worker.Client, as: WorkerClient

  def child_spec(_) do
    IO.puts("Starting Todo.Database")

    {db_folder, pool_size} = fetch_configs()
    File.mkdir_p!(db_folder)

    :poolboy.child_spec(
      __MODULE__,
      [
        name: {:local, __MODULE__},
        worker_module: Worker,
        size: pool_size
      ],
      [db_folder]
    )
  end

  def store(key, data) do
    {_results, bad_nodes} = replicate_everywhere(key, data)
    Enum.each(bad_nodes, &IO.puts("Todo list store failed on node #{&1}"))

    :ok
  end

  defp replicate_everywhere(key, data) do
    :rpc.multicall(
      __MODULE__,
      :store_local,
      [key, data],
      :timer.seconds(5)
    )
  end

  def store_local(key, data) do
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

  defp fetch_configs do
    config = Application.fetch_env!(:todo, :database)
    db_folder = config |> Keyword.fetch!(:db_folder) |> node_db_folder()
    pool_size = Keyword.fetch!(config, :pool_size)

    {db_folder, pool_size}
  end

  defp node_db_folder(db_folder), do: "#{db_folder}/#{node()}"
end
