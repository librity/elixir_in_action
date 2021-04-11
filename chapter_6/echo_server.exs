defmodule Echo.Server do
  use GenServer

  @impl GenServer
  def handle_call(request, _, state), do: {:reply, request, state}
end

{:ok, pid} = GenServer.start(Echo.Server, nil)
GenServer.call(pid, :howdy)

GenServer.start(Echo.Server, nil, name: :echo_server)
GenServer.call(:echo_server, :howdy)
GenServer.call(:echo_server, 42)

GenServer.start(Echo.Server, nil, name: Echo.Server)
GenServer.call(Echo.Server, :howdy)
GenServer.call(Echo.Server, 42)
