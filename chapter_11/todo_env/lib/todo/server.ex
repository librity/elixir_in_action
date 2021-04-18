defmodule Todo.Server do
  use GenServer, restart: :temporary

  alias Todo.Database.Client, as: DatabaseClient
  alias Todo.List
  alias Todo.ProcessRegistry

  @idle_timeout :timer.seconds(10)

  def start_link(name) do
    IO.puts("Starting Todo.Server '#{name}'")

    GenServer.start_link(Todo.Server, name, name: via_tuple(name))
  end

  defp via_tuple(name), do: ProcessRegistry.via_tuple({__MODULE__, name})

  @impl GenServer
  def init(name), do: {:ok, DatabaseClient.get(name) || List.new([], name), @idle_timeout}

  @impl GenServer
  def handle_call({:all}, _caller, todo), do: List.all(todo) |> refresh_call(todo)

  def handle_call({:by_date, date}, _caller, todo),
    do: List.by_date(todo, date) |> refresh_call(todo)

  def handle_call({:entries, date}, _caller, todo),
    do: List.entries(todo, date) |> refresh_call(todo)

  def handle_call({:by_title, title}, _caller, todo),
    do: List.by_title(todo, title) |> refresh_call(todo)

  def handle_call({:by_id, id}, _caller, todo), do: List.by_id(todo, id) |> refresh_call(todo)
  def handle_call(_bad_request, _caller, todo), do: :bad_request |> refresh_call(todo)

  defp refresh_call(response, todo), do: {:reply, response, todo, @idle_timeout}

  @impl GenServer
  def handle_cast({:add_entry, entry}, todo), do: List.add_entry(todo, entry) |> persist!()
  def handle_cast({:update_entry, entry}, todo), do: List.update_entry(todo, entry) |> persist!()

  def handle_cast({:update_entry, entry_id, updater_fun}, todo),
    do: List.update_entry(todo, entry_id, updater_fun) |> persist!()

  def handle_cast({:delete_entry, entry_id}, todo),
    do: List.delete_entry(todo, entry_id) |> persist!()

  def handle_cast(_bad_request, todo), do: refresh_cast(todo)

  defp persist!(%List{name: name} = todo) do
    DatabaseClient.store(name, todo)

    refresh_cast(todo)
  end

  defp refresh_cast(todo), do: {:noreply, todo, @idle_timeout}

  @impl GenServer
  def handle_info(:timeout, %List{name: name} = todo) do
    IO.puts("Stopping Todo.Server '#{name}' due to inactivity")

    {:stop, :normal, todo}
  end
end
