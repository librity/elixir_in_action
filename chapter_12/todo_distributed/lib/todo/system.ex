defmodule Todo.System do
  use Supervisor

  alias Todo.{Cache, Database, Metrics, Web}

  def start_link, do: Supervisor.start_link(__MODULE__, nil, name: __MODULE__)

  def init(_) do
    Supervisor.init(
      [Metrics, Database, Cache, Web],
      strategy: :one_for_one
    )
  end
end
