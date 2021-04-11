defmodule DatabaseServer do
  @query_time 2000

  def start do
    spawn(fn ->
      connection = :rand.uniform(1000)
      loop(connection)
    end)
  end

  def run_async(pid, query_def), do: send(pid, {:run_query, self(), query_def})

  def get_result do
    receive do
      {:query_result, result} -> result
    after
      5000 -> {:error, :timeout}
    end
  end

  defp loop(connection) do
    receive do
      {:run_query, caller, query_def} ->
        query_result = run_query(connection, query_def)
        send(caller, {:query_result, query_result})
    end

    loop(connection)
  end

  defp run_query(connection, query_def) do
    Process.sleep(@query_time)
    "Connection #{connection}: #{query_def} result"
  end
end

pid = DatabaseServer.start()
DatabaseServer.run_async(pid, "query 1")
DatabaseServer.get_result()
DatabaseServer.run_async(pid, "query 2")
DatabaseServer.get_result()

pool = Enum.map(1..100, fn _ -> DatabaseServer.start() end)

Enum.each(1..5, fn query_def ->
  random_server = Enum.at(pool, :rand.uniform(100) - 1)
  DatabaseServer.run_async(random_server, query_def)
end)

Enum.map(1..5, fn _ -> DatabaseServer.get_result() end)
