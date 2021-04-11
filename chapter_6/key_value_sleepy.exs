defmodule KeyValue.Sleepy do
  use GenServer

  @short_term_memory 1000

  @impl true
  def init(_) do
    wakeup_chance = :rand.uniform(100) / 100

    yell(wakeup_chance)
  end

  defp yell(wakeup_chance) when wakeup_chance < 0.33, do: {:stop, "Server is hungover"}
  defp yell(wakeup_chance) when wakeup_chance > 0.33 and wakeup_chance < 0.66, do: :ignore
  defp yell(_wakeup_chance), do: {:ok, %{}}

  @impl true
  def handle_cast({:put, key, value}, state), do: {:noreply, Map.put(state, key, value)}
  @impl true
  def handle_call({:get, key}, _caller, state), do: {:reply, Map.get(state, key), state}
end

defmodule KeyValue.Sleepy.Client do
  @timeout_limit 1000

  def wake_up do
    case start do
      {:error, _reason} ->
        IO.puts("Server is opening his eyes...")
        wake_up()

      :ignore ->
        IO.puts("Server sat on his bed...")
        wake_up()

      {:ok, _pid} = success ->
        success
    end
  end

  def start, do: GenServer.start(KeyValue.Sleepy, nil)
  def put(pid, key, value), do: GenServer.cast(pid, {:put, key, value})
  def get(pid, key), do: GenServer.call(pid, {:get, key})
  def yank(pid, key), do: GenServer.call(pid, {:get, key}, @timeout_limit)
end

KeyValue.Sleepy.Client.start()
KeyValue.Sleepy.Client.start()
KeyValue.Sleepy.Client.start()
KeyValue.Sleepy.Client.start()

{:ok, pid} = KeyValue.Sleepy.Client.wake_up()
KeyValue.Sleepy.Client.put(pid, :ft, "born2code")
KeyValue.Sleepy.Client.get(pid, :ft)
KeyValue.Sleepy.Client.yank(pid, :ft)
