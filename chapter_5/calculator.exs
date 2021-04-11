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
        {:value_request, caller} -> handle_value(caller, value)
        {:add_request, factor} -> handle_add(value, factor)
        {:sub_request, factor} -> handle_sub(value, factor)
        {:mul_request, factor} -> handle_mul(value, factor)
        {:div_request, factor} -> handle_div(value, factor)
        bad_request -> handle_bad_request(bad_request, value)
      end

    loop(new_value)
  end

  defp handle_value(caller, value) do
    send(caller, {:value_response, value})

    value
  end

  defp handle_add(value, factor), do: value + factor
  defp handle_sub(value, factor), do: value - factor
  defp handle_mul(value, factor), do: value * factor
  defp handle_div(value, factor), do: value / factor

  defp handle_bad_request(request, value) do
    IO.puts("Invalid request: #{inspect(request)}")

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
