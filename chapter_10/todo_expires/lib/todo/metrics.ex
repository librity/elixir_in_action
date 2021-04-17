defmodule Todo.Metrics do
  use Task

  @frequency :timer.seconds(10)

  def start_link(_), do: Task.start_link(&loop/0)

  defp loop do
    @frequency |> Process.sleep()
    collect_metrics() |> IO.inspect()
    loop()
  end

  defp collect_metrics,
    do: [
      memory_usage: :erlang.memory(:total),
      process_count: :erlang.system_info(:process_count)
    ]
end
