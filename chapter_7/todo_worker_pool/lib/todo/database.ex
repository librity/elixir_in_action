defmodule Todo.Database do
  use GenServer

  @db_folder "./persist"

  @impl GenServer
  def init(_) do
    File.mkdir_p!(@db_folder)

    {:ok, nil}
  end

  @impl GenServer
  def handle_cast({:store, key, data}, nil) do
    spawn(fn -> key |> file_name() |> File.write!(:erlang.term_to_binary(data)) end)

    {:noreply, nil}
  end

  def handle_cast(_bad_request, nil), do: {:noreply, nil}

  @impl GenServer
  def handle_call({:get, key}, caller, nil) do
    spawn(fn ->
      data =
        case key |> file_name() |> File.read() do
          {:ok, contents} -> :erlang.binary_to_term(contents)
          _ -> nil
        end

      GenServer.reply(caller, data)
    end)

    {:noreply, nil}
  end

  def handle_call(_bad_request, _caller, nil), do: {:reply, :bad_request, nil}

  defp file_name(key), do: Path.join(@db_folder, to_string(key))
end
