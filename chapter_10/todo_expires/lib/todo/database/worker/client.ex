defmodule Todo.Database.Worker.Client do
  alias Todo.Database.Worker

  defdelegate start_link(params), to: Worker

  def store(worker_id, key, data),
    do: worker_id |> Worker.via_tuple() |> GenServer.cast({:store, key, data})

  def get(worker_id, key), do: worker_id |> Worker.via_tuple() |> GenServer.call({:get, key})
end
