defmodule Todo.Database.Worker do
  use GenServer

  def start_link(db_folder) do
    return = {:ok, pid} = GenServer.start_link(__MODULE__, db_folder)
    IO.puts("Starting Todo.Database.Worker #{inspect(pid)}")

    return
  end

  @impl GenServer
  def init(db_folder), do: {:ok, db_folder}

  @impl GenServer
  def handle_cast({:store, key, data}, db_folder) do
    key
    |> file_name(db_folder)
    |> File.write!(:erlang.term_to_binary(data))

    {:noreply, db_folder}
  end

  def handle_cast(_bad_request, db_folder), do: {:noreply, db_folder}

  @impl GenServer
  def handle_call({:get, key}, _caller, db_folder) do
    data =
      case key |> file_name(db_folder) |> File.read() do
        {:ok, contents} -> :erlang.binary_to_term(contents)
        {:error, :enoent} -> nil
      end

    {:reply, data, db_folder}
  end

  def handle_call(_bad_request, _caller, db_folder), do: {:reply, :bad_request, db_folder}

  defp file_name(key, db_folder), do: Path.join(db_folder, to_string(key))
end
