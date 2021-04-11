defmodule Echo.Server.Bad do
  use GenServer

  @impl GenServer
  def handle_call(request, state), do: {:reply, request, state}
end

{:ok, pid} = GenServer.start(Echo.Server.Bad, nil)
GenServer.call(pid, :howdy)
