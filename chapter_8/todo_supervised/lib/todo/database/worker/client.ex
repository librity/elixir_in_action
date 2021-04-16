defmodule Todo.Database.Worker.Client do
  def start(db_folder, index) do
    IO.puts("Starting todo database worker ##{index}.")

    GenServer.start(Todo.Database.Worker, db_folder)
  end

  def store(pid, key, data), do: GenServer.cast(pid, {:store, key, data})

  def get(pid, key), do: GenServer.call(pid, {:get, key})
end
