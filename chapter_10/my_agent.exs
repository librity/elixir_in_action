defmodule MyAgent do
  use GenServer

  def start_link(init_callback), do: GenServer.start_link(__MODULE__, init_callback)

  def get(pid, callback), do: GenServer.call(pid, {:get, callback})
  def update(pid, callback), do: GenServer.call(pid, {:update, callback})
  def cast(pid, callback), do: GenServer.cast(pid, {:update, callback})

  @impl GenServer
  def init(init_callback), do: {:ok, init_callback.()}

  @impl GenServer
  def handle_call({:get, callback}, _from, state) do
    response = callback.(state)
    {:reply, response, state}
  end

  def handle_call({:update, callback}, _from, state) do
    new_state = callback.(state)
    {:reply, :ok, new_state}
  end

  @impl GenServer
  def handle_cast({:update, callback}, state) do
    new_state = callback.(state)
    {:noreply, new_state}
  end
end

{:ok, pid} = MyAgent.start_link(fn -> %{name: "Camilla Rhodes", age: 20} end)
MyAgent.get(pid, fn state -> state.name end)
MyAgent.update(pid, fn state -> %{state | age: state.age + 1} end)
MyAgent.cast(pid, fn state -> %{state | age: state.age + 1} end)
MyAgent.get(pid, fn state -> state end)

{:ok, counter} = MyAgent.start_link(fn -> 0 end)
spawn(fn -> MyAgent.update(counter, fn count -> count + 1 end) end)
spawn(fn -> MyAgent.cast(counter, fn count -> count + 1 end) end)
MyAgent.get(counter, fn count -> count end)
