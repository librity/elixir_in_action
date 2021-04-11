defmodule Queue do
  @timeout_limit 1000

  def start(initial_queue \\ []), do: spawn(fn -> loop(initial_queue) end)

  def enqueue_async(pid, element) do
    send(pid, {:enqueue, self(), element})

    :ok
  end

  def dequeue_async(pid) do
    send(pid, {:dequeue, self()})

    :ok
  end

  def get_result do
    receive do
      {:enqueue_result, result} -> result
      {:dequeue_result, result} -> result
    after
      @timeout_limit -> {:error, :timeout}
    end
  end

  def enqueue_sync(pid, element) do
    enqueue_async(pid, element)
    get_result()
  end

  def dequeue_sync(pid) do
    dequeue_async(pid)
    get_result()
  end

  defp loop(queue) do
    new_queue =
      receive do
        {:enqueue, caller, element} -> handle_enqueue(caller, element, queue)
        {:dequeue, caller} -> handle_dequeue(caller, queue)
      end

    loop(new_queue)
  end

  defp handle_enqueue(caller, element, queue) do
    new_queue = enqueue_element(element, queue)
    send(caller, {:enqueue_result, new_queue})

    new_queue
  end

  defp handle_dequeue(caller, [head | tails]) do
    send(caller, {:dequeue_result, head})

    tails
  end

  defp handle_dequeue(caller, []) do
    send(caller, {:dequeue_result, nil})

    []
  end

  defp enqueue_element(element, queue), do: List.insert_at(queue, -1, element)
end

pid = Queue.start([1, 2, 3, 4, 5])
Queue.enqueue_async(pid, 66)
Queue.dequeue_async(pid)
Queue.get_result()
Queue.get_result()

Queue.enqueue_sync(pid, 10)
Queue.dequeue_sync(pid)
Queue.dequeue_sync(pid)
Queue.dequeue_sync(pid)
