defmodule Calculator do
  def start, do: spawn(fn -> loop() end)

  def add(pid, factor), do: send(pid, {:add_request, factor})
  def sub(pid, factor), do: send(pid, {:sub_request, factor})
  def mul(pid, factor), do: send(pid, {:mul_request, factor})
  def div(pid, factor), do: send(pid, {:div_request, factor})

  def value(pid) do
    send(pid, {:value_request, self()})

    get_result()
  end

  def get_result do
    receive do
      {:value_response, value} -> value
    after
      1000 -> {:error, :timeout}
    end
  end

  defp loop(value \\ 0) do
    new_value =
      receive do
        message -> process_message(value, message)
      end

    loop(new_value)
  end

  defp process_message(value, {:value_request, caller}) do
    send(caller, {:value_response, value})

    value
  end

  defp process_message(value, {:add_request, factor}), do: value + factor
  defp process_message(value, {:sub_request, factor}), do: value - factor
  defp process_message(value, {:mul_request, factor}), do: value * factor
  defp process_message(value, {:div_request, factor}), do: value / factor

  defp process_message(value, bad_mesage) do
    IO.puts("Invalid request: #{inspect(bad_mesage)}")

    value
  end
end

pid = Calculator.start()
Calculator.value(pid)
Calculator.add(pid, 10)
Calculator.sub(pid, 5)
Calculator.mul(pid, 3)
Calculator.div(pid, 5)
Calculator.value(pid)
send(pid, {:bad, 42})
Calculator.value(pid)
