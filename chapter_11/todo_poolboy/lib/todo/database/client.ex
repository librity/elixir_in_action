defmodule Todo.Database.Client do
  alias Todo.Database

  defdelegate store(key, data), to: Database
  defdelegate get(key), to: Database
end
