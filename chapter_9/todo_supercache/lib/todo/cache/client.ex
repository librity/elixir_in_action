defmodule Todo.Cache.Client do
  alias Todo.Cache

  defdelegate start_link, to: Cache
  defdelegate server_process(list_name), to: Cache
end
