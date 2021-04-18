defmodule Todo.System do
  use Supervisor

  alias Todo.{Cache, Database, Metrics, ProcessRegistry, Web}

  def start_link, do: Supervisor.start_link(__MODULE__, nil, name: __MODULE__)

  def init(_) do
    Supervisor.init(
      [Metrics, ProcessRegistry, Database, Cache, Web],
      strategy: :one_for_one
    )
  end
end
