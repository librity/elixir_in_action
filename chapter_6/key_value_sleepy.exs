defmodule KeyValue.Sleepy do
  use GenServer

  @impl GenServer
  def init(_) do
    wakeup_chance = generate_chance()

    yell!(wakeup_chance)
  end

  defp yell!(wakeup_chance) when wakeup_chance < 0.33, do: {:stop, :hungover}
  defp yell!(wakeup_chance) when wakeup_chance > 0.33 and wakeup_chance < 0.66, do: :ignore
  defp yell!(_wakeup_chance), do: {:ok, %{}}

  @impl GenServer
  def handle_cast({:put, key, value}, state),
    do: respond_or_sleep!({:noreply, Map.put(state, key, value)}, state)

  @impl GenServer
  def handle_call({:get, key}, _caller, state),
    do: respond_or_sleep!({:reply, Map.get(state, key), state}, state)

  defp respond_or_sleep!(response, state) do
    back_to_bed_chance = generate_chance()

    if back_to_bed_chance < 0.5 do
      IO.puts("Server went back to bed... 😴")
      {:stop, :back_to_bed, state}
    else
      response
    end
  end

  defp generate_chance, do: :rand.uniform(100) / 100
end

defmodule KeyValue.Sleepy.Client do
  @timeout_limit 1000

  def wake_up do
    case start do
      {:error, _reason} ->
        IO.puts("Server opened his eyes... 🥱")
        wake_up()

      :ignore ->
        IO.puts("Server sat on his bed... 😪")
        wake_up()

      {:ok, _pid} = success ->
        IO.puts("Server got out of bed! 😫")
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
