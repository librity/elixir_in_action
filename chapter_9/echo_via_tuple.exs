defmodule Echo.Server do
  use GenServer

  def start_link(id), do: GenServer.start_link(__MODULE__, nil, name: via_tuple(id))

  def call(id, request), do: GenServer.call(via_tuple(id), request)

  defp via_tuple(id), do: {:via, Registry, {:my_registry, {__MODULE__, id}}}

  @impl GenServer
  def handle_call(request, _, state), do: {:reply, request, state}
end

Registry.start_link(name: :my_registry, keys: :unique)
Echo.Server.start_link("garmon")
Echo.Server.start_link(:laura)
Echo.Server.call("garmon", "bozia")
Echo.Server.call(:laura, :palmer)
