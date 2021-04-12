defmodule Todo.Server.Store do
  def start, do: GenServer.start(Todo.Server, nil, name: __MODULE__)

  def all(), do: GenServer.call(__MODULE__, {:all})
  def by_date(date), do: GenServer.call(__MODULE__, {:by_date, date})
  def entries(date), do: by_date(date)
  def by_title(title), do: GenServer.call(__MODULE__, {:by_title, title})
  def by_id(id), do: GenServer.call(__MODULE__, {:by_id, id})

  def add_entry(entry), do: GenServer.cast(__MODULE__, {:add_entry, entry})
  def update_entry(entry), do: GenServer.cast(__MODULE__, {:update_entry, entry})

  def update_entry(entry_id, updater_fun),
    do: GenServer.cast(__MODULE__, {:update_entry, entry_id, updater_fun})

  def delete_entry(entry_id), do: GenServer.cast(__MODULE__, {:delete_entry, entry_id})
end
