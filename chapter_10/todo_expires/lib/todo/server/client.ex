defmodule Todo.Server.Client do
  alias Todo.Server

  defdelegate start_link(params), to: Server

  defdelegate all(pid), to: Server
  defdelegate by_date(pid, date), to: Server
  defdelegate entries(pid, date), to: Server
  defdelegate by_title(pid, title), to: Server
  defdelegate by_id(pid, id), to: Server

  defdelegate add_entry(pid, entry), to: Server
  defdelegate update_entry(pid, entry), to: Server
  defdelegate update_entry(pid, entry_id, updater_fun), to: Server
  defdelegate delete_entry(pid, entry_id), to: Server
end
