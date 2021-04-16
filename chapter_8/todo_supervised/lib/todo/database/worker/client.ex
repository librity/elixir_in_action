defmodule Todo.Database.Worker.Client do
  def start(db_folder), do: GenServer.start(Todo.Database.Worker, db_folder)

  def store(pid, key, data), do: GenServer.cast(pid, {:store, key, data})

  def get(pid, key), do: GenServer.call(pid, {:get, key})
end
