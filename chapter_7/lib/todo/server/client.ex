defmodule Todo.Server.Client do
  def start, do: GenServer.start(Todo.Server, nil)

  def all(pid), do: GenServer.call(pid, {:all})
  def by_date(pid, date), do: GenServer.call(pid, {:by_date, date})
  def by_title(pid, title), do: GenServer.call(pid, {:by_title, title})
  def by_id(pid, id), do: GenServer.call(pid, {:by_id, id})

  def add_entry(pid, entry), do: GenServer.cast(pid, {:add_entry, entry})
  def update_entry(pid, entry), do: GenServer.cast(pid, {:update_entry, entry})

  def update_entry(pid, entry_id, updater_fun),
    do: GenServer.cast(pid, {:update_entry, entry_id, updater_fun})

  def delete_entry(pid, entry_id), do: GenServer.cast(pid, {:delete_entry, entry_id})
end
