defmodule KeyValue do
  use GenServer

  @impl GenServer
  def init(_), do: {:ok, %{}}
  @impl GenServer
  def handle_cast({:put, key, value}, state), do: {:noreply, Map.put(state, key, value)}
  @impl GenServer
  def handle_call({:get, key}, _caller, state), do: {:reply, Map.get(state, key), state}
end

defmodule KeyValue.Client.Singleton do
  @timeout_limit 1000

  def start, do: GenServer.start(KeyValue, nil, name: __MODULE__)
  def put(key, value), do: GenServer.cast(__MODULE__, {:put, key, value})
  def get(key), do: GenServer.call(__MODULE__, {:get, key})
  def yank(key), do: GenServer.call(__MODULE__, {:get, key}, @timeout_limit)
end

KeyValue.Client.Singleton.start()
KeyValue.Client.Singleton.put(:ft, "born2code")
KeyValue.Client.Singleton.get(:ft)
KeyValue.Client.Singleton.yank(:ft)
KeyValue.Client.Singleton.start()
