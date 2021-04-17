defmodule Todo.Server do
  use Agent, restart: :temporary

  alias Todo.Database.Client, as: DatabaseClient
  alias Todo.List
  alias Todo.ProcessRegistry

  def start_link(name) do
    Agent.start_link(
      fn ->
        IO.puts("Starting Todo.Server '#{name}'")

        DatabaseClient.get(name) || List.new([], name)
      end,
      name: via_tuple(name)
    )
  end

  defp via_tuple(name), do: ProcessRegistry.via_tuple({__MODULE__, name})

  def all(pid), do: Agent.get(pid, fn todo -> List.all(todo) end)

  def by_date(pid, date), do: Agent.get(pid, fn todo -> List.by_date(todo, date) end)

  def entries(pid, date), do: Agent.get(pid, fn todo -> List.entries(todo, date) end)

  def by_title(pid, title), do: Agent.get(pid, fn todo -> List.by_title(todo, title) end)

  def by_id(pid, id), do: Agent.get(pid, fn todo -> List.by_id(todo, id) end)

  def add_entry(pid, entry),
    do: Agent.cast(pid, fn todo -> List.add_entry(todo, entry) |> persist!() end)

  def update_entry(pid, entry),
    do: Agent.cast(pid, fn todo -> List.update_entry(todo, entry) |> persist!() end)

  def update_entry(pid, entry_id, updater_fun) do
    Agent.cast(
      pid,
      fn todo -> List.update_entry(todo, entry_id, updater_fun) |> persist!() end
    )
  end

  def delete_entry(pid, entry_id),
    do: Agent.cast(pid, fn todo -> List.delete_entry(todo, entry_id) |> persist!() end)

  defp persist!(%List{name: name} = todo) do
    DatabaseClient.store(name, todo)

    todo
  end
end
