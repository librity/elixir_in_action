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
  @timeout_limit 1000

  def start, do: spawn(fn -> loop() end)

  def add_entry(pid, entry), do: send(pid, {:add_entry, entry})
  def delete_entry(pid, entry_id), do: send(pid, {:delete_entry, entry_id})
  def update_entry(pid, entry), do: send(pid, {:update_entry, entry})

  def update_entry(pid, entry_id, updater_fun),
    do: send(pid, {:update_entry, entry_id, updater_fun})

  def all(pid) do
    send(pid, {:all_request, self()})
    get_respose()
  end

  def by_id(pid, id) do
    send(pid, {:by_id_request, self(), id})
    get_respose()
  end

  def by_title(pid, title) do
    send(pid, {:by_title_request, self(), title})
    get_respose()
  end

  def by_date(pid, date) do
    send(pid, {:by_date_request, self(), date})
    get_respose()
  end

  def get_respose do
    receive do
      {:entries_response, entries} -> entries
    after
      @timeout_limit -> {:error, :timeout}
    end
  end

  defp loop(todo \\ Todo.new()) do
    new_todo =
      receive do
        message -> process_message(todo, message)
      end

    loop(new_todo)
  end

  defp process_message(todo, {:add_entry, entry}), do: Todo.add_entry(todo, entry)
  defp process_message(todo, {:delete_entry, entry_id}), do: Todo.delete_entry(todo, entry_id)

  defp process_message(todo, {:update_entry, entry}), do: Todo.update_entry(todo, entry)

  defp process_message(todo, {:update_entry, entry_id, updater_fun}),
    do: Todo.update_entry(todo, entry_id, updater_fun)

  defp process_message(todo, {:all_request, caller}) do
    send(caller, {:entries_response, todo})

    todo
  end

  defp process_message(todo, {:by_id_request, caller, id}) do
    send(caller, {:entries_response, Todo.by_id(todo, id)})

    todo
  end

  defp process_message(todo, {:by_title_request, caller, title}) do
    send(caller, {:entries_response, Todo.by_title(todo, title)})

    todo
  end

  defp process_message(todo, {:by_date_request, caller, date}) do
    send(caller, {:entries_response, Todo.by_date(todo, date)})

    todo
  end

  defp process_message(todo, bad_mesage) do
    IO.puts("Invalid request: #{inspect(bad_mesage)}")

    todo
  end
end

defmodule Todo.Server.Registered do
  alias Todo.Server

  @name :todo_server

  def start do
    pid = Todo.Server.start()

    Process.register(pid, @name)
  end

  def add_entry(entry), do: Server.add_entry(@name, entry)
  def delete_entry(entry_id), do: Server.delete_entry(@name, entry_id)
  def update_entry(entry), do: Server.update_entry(@name, entry)
  def update_entry(entry_id, updater_fun), do: Server.update_entry(@name, entry_id, updater_fun)

  def all(), do: Server.all(@name)
  def by_id(id), do: Server.by_id(@name, id)
  def by_title(title), do: Server.by_title(@name, title)
  def by_date(date), do: Server.by_date(@name, date)
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
