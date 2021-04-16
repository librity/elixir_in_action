defmodule Todo.Server do
  use GenServer

  alias Todo.List
  alias Todo.Database.Client, as: DatabaseClient

  @impl GenServer
  def init(name), do: {:ok, DatabaseClient.get(name) || List.new([], name)}

  @impl GenServer
  def handle_call({:all}, _caller, todo), do: {:reply, List.all(todo), todo}
  def handle_call({:by_date, date}, _caller, todo), do: {:reply, List.by_date(todo, date), todo}
  def handle_call({:entries, date}, _caller, todo), do: {:reply, List.entries(todo, date), todo}

  def handle_call({:by_title, title}, _caller, todo),
    do: {:reply, List.by_title(todo, title), todo}

  def handle_call({:by_id, id}, _caller, todo), do: {:reply, List.by_id(todo, id), todo}
  def handle_call(_bad_request, _caller, todo), do: {:reply, :bad_request, todo}

  @impl GenServer
  def handle_cast({:add_entry, entry}, todo), do: List.add_entry(todo, entry) |> persist!()
  def handle_cast({:update_entry, entry}, todo), do: List.update_entry(todo, entry) |> persist!()

  def handle_cast({:update_entry, entry_id, updater_fun}, todo),
    do: List.update_entry(todo, entry_id, updater_fun) |> persist!()

  def handle_cast({:delete_entry, entry_id}, todo),
    do: List.delete_entry(todo, entry_id) |> persist!()

  def handle_cast(_bad_request, todo), do: {:noreply, todo}

  defp persist!(%List{name: name} = todo) do
    DatabaseClient.store(name, todo)

    {:noreply, todo}
  end
end
