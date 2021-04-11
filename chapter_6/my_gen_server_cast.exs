defmodule MyGenServer do
  def start(callback_module) do
    spawn(fn ->
      initial_state = callback_module.init()
      loop(callback_module, initial_state)
    end)
  end

  def call(pid, request) do
    send(pid, {:call, request, self()})

    receive do
      {:response, response} -> response
    end
  end

  def cast(pid, request), do: send(pid, {:cast, request})

  defp loop(callback_module, state) do
    receive do
      {:call, request, caller} ->
        {response, new_state} = callback_module.handle_call(request, state)
        send(caller, {:response, response})
        loop(callback_module, new_state)

      {:cast, request} ->
        new_state = callback_module.handle_cast(request, state)
        loop(callback_module, new_state)
    end
  end
end

defmodule KeyValue do
  def init, do: %{}

  def handle_call({:get, key}, state), do: {Map.get(state, key), state}
  def handle_call(_bad_request, state), do: {:bad_request, state}

  def handle_cast({:put, key, value}, state), do: Map.put(state, key, value)
  def handle_cast(_bad_request, state), do: state
end

defmodule KeyValue.Client do
  def start, do: MyGenServer.start(KeyValue)

  def get(pid, key), do: MyGenServer.call(pid, {:get, key})

  def put(pid, key, value), do: MyGenServer.cast(pid, {:put, key, value})
end

pid = KeyValue.Client.start()
KeyValue.Client.put(pid, :some_key, :some_value)
KeyValue.Client.get(pid, :some_key)
KeyValue.Client.put(pid, :ft, 42)
KeyValue.Client.get(pid, :ft)
