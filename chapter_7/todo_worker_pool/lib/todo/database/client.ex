defmodule Todo.Database.Client do
  def start, do: GenServer.start(Todo.Database, nil, name: __MODULE__)

  def store(key, data), do: GenServer.cast(__MODULE__, {:store, key, data})

  def get(key), do: GenServer.call(__MODULE__, {:get, key})
end
