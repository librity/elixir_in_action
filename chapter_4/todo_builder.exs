defmodule Todo.Entry do
  @keys [:id, :date, :title]

  @enforce_keys @keys

  defstruct @keys

  def new(id, date, title), do: %__MODULE__{id: id, date: date, title: title}
end

defmodule Todo do
  alias Todo.Entry

  defstruct auto_id: 1, entries: %{}

  def new(entries \\ []), do: Enum.reduce(entries, %__MODULE__{}, &add_entry(&2, &1))

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

  defp handle_update(todo_list, old_entry, updater_fun) do
    old_id = old_entry.id
    new_entry = %Entry{id: ^old_id} = updater_fun.(old_entry)
    new_entries = Map.put(todo_list.entries, new_entry.id, new_entry)

    %__MODULE__{todo_list | entries: new_entries}
  end
end

defmodule Todo.FromCsv do
  def import(file_path) do
    file_path
    |> File.stream!()
    |> Enum.map(&parse_line/1)
    |> Todo.new()
  end

  defp parse_line(line_string) do
    [date, title] =
      line_string
      |> String.trim()
      |> String.split(",")
      |> List.update_at(0, &parse_date/1)

    %{date: date, title: title}
  end

  defp parse_date(string_date) do
    string_date
    |> String.replace("/", "-")
    |> Date.from_iso8601!()
  end
end

entries = [
  %{date: ~D[2018-12-19], title: "Dentist"},
  %{date: ~D[2018-12-20], title: "Shopping"},
  %{date: ~D[2018-12-19], title: "Movies"}
]

Todo.new(entries)

Todo.FromCsv.import("todo.csv")
