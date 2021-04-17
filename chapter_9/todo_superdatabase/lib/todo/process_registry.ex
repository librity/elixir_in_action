defmodule Todo.ProcessRegistry do
  def start_link, do: Registry.start_link(keys: :unique, name: __MODULE__)

  def via_tuple(key), do: {:via, Registry, {__MODULE__, key}}

  def child_spec(_),
    do:
      Supervisor.child_spec(
        Registry,
        id: __MODULE__,
        start: {__MODULE__, :start_link, []}
      )
end
