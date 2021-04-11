defmodule Echo.Server do
  use GenServer

  @impl GenServer
  def handle_call(request, _, state), do: {:reply, request, state}
end

{:ok, pid} = GenServer.start(Echo.Server, nil)
GenServer.call(pid, :howdy)
