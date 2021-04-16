defmodule Todo do
  def init do
    Supervisor.start_link([Todo.Cache], strategy: :one_for_one)
  end
end
