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

todo_list = Todo.new()
todo_list = Todo.add_entry(todo_list, %{date: ~D[2018-12-19], title: "Dentist"})
todo_list = Todo.add_entry(todo_list, %{date: ~D[2018-12-20], title: "Shopping"})
todo_list = Todo.add_entry(todo_list, %{date: ~D[2018-12-19], title: "Movies"})

Todo.by_date(todo_list, ~D[2018-12-19])
Todo.by_date(todo_list, ~D[2018-12-18])

Todo.by_title(todo_list, "Movies")

Todo.by_id(todo_list, 2)

Todo.update_entry(todo_list, 1, &Map.put(&1, :date, ~D[2018-12-20]))
Todo.update_entry(todo_list, 1, &Map.put(&1, :title, "Zoo"))
Todo.update_entry(todo_list, 8, &Map.put(&1, :title, "Zoo"))

Todo.update_entry(todo_list, Todo.Entry.new(1, ~D[2021-12-20], "Rock climbing"))
Todo.update_entry(todo_list, Todo.Entry.new(8, ~D[2021-12-20], "Rock climbing"))

Todo.delete_entry(todo_list, 1)
Todo.delete_entry(todo_list, 8)
