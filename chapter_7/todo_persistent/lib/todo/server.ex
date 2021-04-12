defmodule Todo.Server do
  use GenServer

  alias Todo.List

  @impl GenServer
  def init(_), do: {:ok, List.new()}

  @impl GenServer
  def handle_call({:all}, _caller, todo), do: {:reply, List.all(todo), todo}
  def handle_call({:by_date, date}, _caller, todo), do: {:reply, List.by_date(todo, date), todo}
  def handle_call({:entries, date}, _caller, todo), do: {:reply, List.entries(todo, date), todo}

  def handle_call({:by_title, title}, _caller, todo),
    do: {:reply, List.by_title(todo, title), todo}

  def handle_call({:by_id, id}, _caller, todo), do: {:reply, List.by_id(todo, id), todo}
  def handle_call(_bad_request, _caller, todo), do: {:reply, :bad_request, todo}

  @impl GenServer
  def handle_cast({:add_entry, entry}, todo), do: {:noreply, List.add_entry(todo, entry)}
  def handle_cast({:update_entry, entry}, todo), do: {:noreply, List.update_entry(todo, entry)}

  def handle_cast({:update_entry, entry_id, updater_fun}, todo),
    do: {:noreply, List.update_entry(todo, entry_id, updater_fun)}

  def handle_cast({:delete_entry, entry_id}, todo),
    do: {:noreply, List.delete_entry(todo, entry_id)}

  def handle_cast(_bad_request, todo), do: {:noreply, todo}
end
