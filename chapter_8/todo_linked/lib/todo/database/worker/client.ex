defmodule Todo.Database.Worker.Client do
  alias Todo.Database.Worker

  defdelegate start_link(params), to: Worker

  def store(pid, key, data), do: GenServer.cast(pid, {:store, key, data})

  def get(pid, key), do: GenServer.call(pid, {:get, key})
end
