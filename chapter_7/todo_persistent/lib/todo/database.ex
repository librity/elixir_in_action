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
    key
    |> file_name()
    |> File.write!(:erlang.term_to_binary(data))

    {:noreply, nil}
  end

  @impl GenServer
  def handle_call({:get, key}, _, nil) do
    data =
      case key |> file_name() |> File.read() do
        {:ok, contents} -> :erlang.binary_to_term(contents)
        _ -> nil
      end

    {:reply, data, nil}
  end

  defp file_name(key), do: Path.join(@db_folder, to_string(key))
end
