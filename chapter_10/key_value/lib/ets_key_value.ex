# mix run -e "Bench.run(EtsKeyValue)"
# mix run -e "Bench.run(EtsKeyValue, concurrency: 1000)"
# mix run -e "Bench.run(EtsKeyValue, concurrency: 1000, num_updates: 100)"

defmodule EtsKeyValue do
  use GenServer

  def start_link, do: GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  def put(key, value), do: :ets.insert(__MODULE__, {key, value})

  def get(key) do
    case :ets.lookup(__MODULE__, key) do
      [{^key, value}] -> value
      [] -> nil
    end
  end

  @impl GenServer
  def init(_) do
    :ets.new(__MODULE__, [:named_table, :public, write_concurrency: true])

    {:ok, nil}
  end
end
