defmodule Server do
  def start, do: spawn(&loop/0)

  def send_msg(server, message) do
    send(server, {self(), message})

    receive do
      {:response, response} -> response
    end
  end

  defp loop do
    receive do
      {caller, msg} ->
        Process.sleep(1000)
        send(caller, {:response, msg})
    end

    loop()
  end
end

pid = Server.start()

Enum.each(
  1..5,
  fn i ->
    spawn(fn ->
      IO.puts("Sending msg ##{i}")
      response = Server.send_msg(pid, i)
      IO.puts("Response: #{response}")
    end)
  end
)
