defmodule MyGenServer do
  def start(callback_module) do
    spawn(fn ->
      initial_state = callback_module.init()
      loop(callback_module, initial_state)
    end)
  end

  def call(pid, request) do
    send(pid, {request, self()})

    receive do
      {:response, response} -> response
    end
  end

  defp loop(callback_module, state) do
    receive do
      {request, caller} ->
        {response, new_state} = callback_module.handle_call(request, state)
        send(caller, {:response, response})
        loop(callback_module, new_state)
    end
  end
end

defmodule KeyValue do
  @impl true
  def init, do: %{}
  @impl true
  def handle_call({:put, key, value}, state), do: {:ok, Map.put(state, key, value)}
  def handle_call({:get, key}, state), do: {Map.get(state, key), state}
  def handle_call(bad_request, state), do: {:bad_request, state}
end

defmodule KeyValue.Client do
  def start, do: MyGenServer.start(KeyValue)
  def put(pid, key, value), do: MyGenServer.call(pid, {:put, key, value})
  def get(pid, key), do: MyGenServer.call(pid, {:get, key})
end

pid = MyGenServer.start(KeyValue)
MyGenServer.call(pid, {:put, :some_key, :some_value})
MyGenServer.call(pid, {:get, :some_key})
MyGenServer.call(pid, {:bad, :some_key})

pid = KeyValue.Client.start()
KeyValue.Client.put(pid, :some_key, :some_value)
KeyValue.Client.get(pid, :some_key)
