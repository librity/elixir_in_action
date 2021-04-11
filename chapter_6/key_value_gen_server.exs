defmodule KeyValue do
  use GenServer

  @impl GenServer
  def init(_), do: {:ok, %{}}
  @impl GenServer
  def handle_cast({:put, key, value}, state), do: {:noreply, Map.put(state, key, value)}
  @impl GenServer
  def handle_call({:get, key}, _caller, state), do: {:reply, Map.get(state, key), state}
end

defmodule KeyValue.Client do
  @timeout_limit 0

  def start, do: GenServer.start(KeyValue, nil)
  def put(pid, key, value), do: GenServer.cast(pid, {:put, key, value})
  def get(pid, key), do: GenServer.call(pid, {:get, key})
  def yank(pid, key), do: GenServer.call(pid, {:get, key}, @timeout_limit)
end

{:ok, pid} = GenServer.start(KeyValue, nil)
GenServer.cast(pid, {:put, :ft, 42})
GenServer.call(pid, {:get, :ft})

{:ok, pid} = KeyValue.Client.start()
KeyValue.Client.put(pid, :ft, "born2code")
KeyValue.Client.get(pid, :ft)
KeyValue.Client.yank(pid, :ft)
