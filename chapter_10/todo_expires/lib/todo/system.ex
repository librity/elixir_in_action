defmodule Todo.System do
  use Supervisor

  alias Todo.{Cache, Database, Metrics, ProcessRegistry}

  def start_link, do: Supervisor.start_link(__MODULE__, nil)

  def init(_) do
    Supervisor.init([Metrics, ProcessRegistry, Database, Cache], strategy: :one_for_one)
  end
end
