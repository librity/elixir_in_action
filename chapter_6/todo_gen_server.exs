defmodule Todo.Entry do
  @keys [:id, :date, :title]

  @enforce_keys @keys

  defstruct @keys

  def new(id, date, title), do: %__MODULE__{id: id, date: date, title: title}
end

defmodule Todo do
  alias Todo.Entry

  defstruct auto_id: 1, entries: %{}

  def new, do: %__MODULE__{}

  def add_entry(
        %__MODULE__{auto_id: auto_id, entries: old_entries} = todo_list,
        %{date: date, title: title}
      ) do
    entry = Entry.new(auto_id, date, title)
    new_entries = Map.put(old_entries, auto_id, entry)

    %__MODULE__{todo_list | auto_id: auto_id + 1, entries: new_entries}
  end

  def all(%__MODULE__{entries: entries}), do: Enum.map(entries, fn {_id, entry} -> entry end)
  def by_date(%__MODULE__{} = todo_list, date), do: by_key(todo_list, date, :date)
  def by_id(%__MODULE__{} = todo_list, id), do: by_key(todo_list, id, :id)
  def by_title(%__MODULE__{} = todo_list, title), do: by_key(todo_list, title, :title)

  defp by_key(todo_list, query, key) do
    todo_list.entries
    |> Stream.filter(fn {_id, %Entry{} = entry} -> Map.get(entry, key) == query end)
    |> Enum.map(fn {_id, entry} -> entry end)
  end

  def update_entry(%__MODULE__{} = todo_list, %Entry{} = new_entry) do
    update_entry(todo_list, new_entry.id, fn _ -> new_entry end)
  end

  def update_entry(%__MODULE__{} = todo_list, entry_id, updater_fun) do
    case Map.fetch(todo_list.entries, entry_id) do
      :error -> todo_list
      {:ok, old_entry} -> handle_update(todo_list, old_entry, updater_fun)
    end
  end

  defp handle_update(todo_list, %Entry{id: id} = old_entry, updater_fun) do
    new_entry = %Entry{id: ^id} = updater_fun.(old_entry)

    put_in(todo_list.entries[id], new_entry)
  end

  def delete_entry(%__MODULE__{} = todo_list, entry_id) do
    case Map.fetch(todo_list.entries, entry_id) do
      :error -> todo_list
      {:ok, %Entry{id: entry_id}} -> handle_delete(todo_list, entry_id)
    end
  end

  defp handle_delete(todo_list, entry_id),
    do: put_in(todo_list.entries, Map.delete(todo_list.entries, entry_id))
end

defmodule Todo.Server do
  use GenServer

  @impl GenServer
  def init(_), do: {:ok, Todo.new()}

  @impl GenServer
  def handle_call({:all}, _caller, todo), do: {:reply, Todo.all(todo), todo}
  def handle_call({:by_date, date}, _caller, todo), do: {:reply, Todo.by_date(todo, date), todo}

  def handle_call({:by_title, title}, _caller, todo),
    do: {:reply, Todo.by_title(todo, title), todo}

  def handle_call({:by_id, id}, _caller, todo), do: {:reply, Todo.by_id(todo, id), todo}
  def handle_call(_bad_request, _caller, todo), do: {:reply, :bad_request, todo}

  @impl GenServer
  def handle_cast({:add_entry, entry}, todo), do: {:noreply, Todo.add_entry(todo, entry)}
  def handle_cast({:update_entry, entry}, todo), do: {:noreply, Todo.update_entry(todo, entry)}

  def handle_cast({:update_entry, entry_id, updater_fun}, todo),
    do: {:noreply, Todo.update_entry(todo, entry_id, updater_fun)}

  def handle_cast({:delete_entry, entry_id}, todo),
    do: {:noreply, Todo.delete_entry(todo, entry_id)}

  def handle_cast(_bad_request, todo), do: {:noreply, todo}
end

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

{:ok, pid} = Todo.Server.Client.start()
Todo.Server.Client.add_entry(pid, %{date: ~D[2018-12-19], title: "Dentist"})
Todo.Server.Client.add_entry(pid, %{date: ~D[2018-12-20], title: "Shopping"})
Todo.Server.Client.add_entry(pid, %{date: ~D[2018-12-19], title: "Movies"})
Todo.Server.Client.all(pid)
Todo.Server.Client.by_date(pid, ~D[2018-12-19])

Todo.Server.Client.by_date(pid, ~D[2018-12-19])
Todo.Server.Client.by_date(pid, ~D[2018-12-18])

Todo.Server.Client.by_title(pid, "Movies")

Todo.Server.Client.by_id(pid, 2)

Todo.Server.Client.update_entry(pid, 1, &Map.put(&1, :date, ~D[2018-12-20]))
Todo.Server.Client.update_entry(pid, 1, &Map.put(&1, :title, "Zoo"))
Todo.Server.Client.update_entry(pid, 8, &Map.put(&1, :title, "Zoo"))
Todo.Server.Client.all(pid)

Todo.Server.Client.update_entry(pid, Todo.Entry.new(1, ~D[2021-12-20], "Rock climbing"))
Todo.Server.Client.update_entry(pid, Todo.Entry.new(8, ~D[2021-12-20], "Rock climbing"))
Todo.Server.Client.all(pid)

Todo.Server.Client.delete_entry(pid, 1)
Todo.Server.Client.delete_entry(pid, 8)
Todo.Server.Client.all(pid)

defmodule Todo.Server.Registered do
  def start, do: GenServer.start(Todo.Server, nil, name: __MODULE__)

  def all(), do: GenServer.call(__MODULE__, {:all})
  def by_date(date), do: GenServer.call(__MODULE__, {:by_date, date})
  def by_title(title), do: GenServer.call(__MODULE__, {:by_title, title})
  def by_id(id), do: GenServer.call(__MODULE__, {:by_id, id})

  def add_entry(entry), do: GenServer.cast(__MODULE__, {:add_entry, entry})
  def update_entry(entry), do: GenServer.cast(__MODULE__, {:update_entry, entry})

  def update_entry(entry_id, updater_fun),
    do: GenServer.cast(__MODULE__, {:update_entry, entry_id, updater_fun})

  def delete_entry(entry_id), do: GenServer.cast(__MODULE__, {:delete_entry, entry_id})
end

Todo.Server.Registered.start()
Todo.Server.Registered.add_entry(%{date: ~D[2018-12-19], title: "Dentist"})
Todo.Server.Registered.add_entry(%{date: ~D[2018-12-20], title: "Shopping"})
Todo.Server.Registered.add_entry(%{date: ~D[2018-12-19], title: "Movies"})
Todo.Server.Registered.all()
Todo.Server.Registered.by_date(~D[2018-12-19])

Todo.Server.Registered.by_date(~D[2018-12-19])
Todo.Server.Registered.by_date(~D[2018-12-18])

Todo.Server.Registered.by_title("Movies")

Todo.Server.Registered.by_id(2)

Todo.Server.Registered.update_entry(1, &Map.put(&1, :date, ~D[2018-12-20]))
Todo.Server.Registered.update_entry(1, &Map.put(&1, :title, "Zoo"))
Todo.Server.Registered.update_entry(8, &Map.put(&1, :title, "Zoo"))
Todo.Server.Registered.all()

Todo.Server.Registered.update_entry(Todo.Entry.new(1, ~D[2021-12-20], "Rock climbing"))
Todo.Server.Registered.update_entry(Todo.Entry.new(8, ~D[2021-12-20], "Rock climbing"))
Todo.Server.Registered.all()

Todo.Server.Registered.delete_entry(1)
Todo.Server.Registered.delete_entry(8)
Todo.Server.Registered.all()
