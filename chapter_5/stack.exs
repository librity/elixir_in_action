defmodule Stack do
  @timeout_limit 1000

  def start(initial_stack \\ []), do: spawn(fn -> loop(initial_stack) end)

  def push_async(pid, element) do
    send(pid, {:push, self(), element})

    :ok
  end

  def pop_async(pid) do
    send(pid, {:pop, self()})

    :ok
  end

  def get_result do
    receive do
      {:push_result, result} -> result
      {:pop_result, result} -> result
    after
      @timeout_limit -> {:error, :timeout}
    end
  end

  def push_sync(pid, element) do
    push_async(pid, element)
    get_result()
  end

  def pop_sync(pid) do
    pop_async(pid)
    get_result()
  end

  defp loop(stack) do
    new_stack =
      receive do
        {:push, caller, element} -> handle_push(caller, element, stack)
        {:pop, caller} -> handle_pop(caller, stack)
      end

    loop(new_stack)
  end

  defp handle_push(caller, element, stack) do
    new_stack = push_element(element, stack)
    send(caller, {:push_result, new_stack})

    new_stack
  end

  defp handle_pop(caller, [head | tails]) do
    send(caller, {:pop_result, head})

    tails
  end

  defp handle_pop(caller, []) do
    send(caller, {:pop_result, nil})

    []
  end

  defp push_element(element, stack), do: [element | stack]
end

pid = Stack.start([1, 2, 3, 4, 5])
Stack.push_async(pid, 66)
Stack.pop_async(pid)
Stack.get_result()
Stack.get_result()

Stack.push_sync(pid, 10)
Stack.pop_sync(pid)
Stack.pop_sync(pid)
Stack.pop_sync(pid)
