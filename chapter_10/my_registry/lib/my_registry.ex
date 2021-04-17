defmodule MyRegistry do
  use GenServer

  @logging false

  def start_link, do: GenServer.start_link(__MODULE__, nil, name: __MODULE__)

  def all, do: :ets.tab2list(__MODULE__)

  def register(name) when is_atom(name) do
    # We're linking to the registry server first, to avoid possible race
    # condition. Note that it's therefore possible that a caller process is
    # linked, even though the registration fails. We can't simply unlink on a
    # failing registration, since a process might be registered under some
    # other term. To properly solve this, we'd need another ETS table to keep
    # track of whether a process is already registered under some other term.
    # To keep things simple, this is not done here. For a proper
    # implementation, you can study the Registry code at:
    # https://github.com/elixir-lang/elixir/blob/master/lib/elixir/lib/registry.ex
    link_to_registry()

    case :ets.insert_new(__MODULE__, {name, self()}) do
      false -> :error
      true -> log_registration(name)
    end
  end

  def register(_name), do: :error

  defp link_to_registry do
    __MODULE__
    |> Process.whereis()
    |> Process.link()
  end

  defp log_registration(name) do
    if @logging,
      do: IO.puts("Registered process #{self() |> inspect()} as '#{name}' in #{__MODULE__}")

    :ok
  end

  def whereis(name) do
    case :ets.lookup(__MODULE__, name) do
      [{^name, pid}] -> pid
      [] -> nil
    end
  end

  @impl GenServer
  def init(_) do
    Process.flag(:trap_exit, true)
    :ets.new(__MODULE__, [:named_table, :public, read_concurrency: true])

    {:ok, nil}
  end

  @impl GenServer
  def handle_info({:EXIT, pid, _reason}, nil) do
    :ets.match_delete(__MODULE__, {:_, pid})
    if @logging, do: IO.puts("Deregistered process #{inspect(pid)} from #{__MODULE__}")

    {:noreply, nil}
  end
end
