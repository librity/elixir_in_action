defmodule KeyValue.Amnesiac do
  use GenServer

  @short_term_memory 1000

  @impl GenServer
  def init(_) do
    :timer.send_interval(@short_term_memory, :cleanup)

    {:ok, %{}}
  end

  @impl GenServer
  def handle_cast({:put, key, value}, state), do: {:noreply, Map.put(state, key, value)}
  @impl GenServer
  def handle_call({:get, key}, _caller, state), do: {:reply, Map.get(state, key), state}
  @impl GenServer
  def handle_info(:cleanup, state) do
    pid = inspect(self())
    IO.puts("Forgetting #{pid}'s KeyValue state:")
    IO.inspect(state)

    {:noreply, %{}}
  end
end

defmodule KeyValue.Amnesiac.Client do
  @timeout_limit 1000

  def start, do: GenServer.start(KeyValue, nil)
  def put(pid, key, value), do: GenServer.cast(pid, {:put, key, value})
  def get(pid, key), do: GenServer.call(pid, {:get, key})
  def yank(pid, key), do: GenServer.call(pid, {:get, key}, @timeout_limit)
end

{:ok, pid} = GenServer.start(KeyValue.Amnesiac, nil)
GenServer.cast(pid, {:put, :ft, 42})
GenServer.call(pid, {:get, :ft})

{:ok, pid} = KeyValue.Amnesiac.Client.start()
KeyValue.Amnesiac.Client.put(pid, :ft, "born2code")
KeyValue.Amnesiac.Client.get(pid, :ft)
KeyValue.Amnesiac.Client.yank(pid, :ft)
KeyValue.Amnesiac.Client.put(pid, :a, 1)
KeyValue.Amnesiac.Client.put(pid, :b, 2)
KeyValue.Amnesiac.Client.put(pid, :c, 3)
