defmodule Todo do
  defdelegate start_link, to: Todo.System
end
