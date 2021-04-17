defmodule Todo.Metrics do
  require Logger

  use Task

  @frequency :timer.minutes(5)

  def start_link(_), do: Task.start_link(&loop/0)

  defp loop do
    @frequency
    |> Process.sleep()

    collect_metrics()
    |> Logger.info()

    loop()
  end

  defp collect_metrics,
    do: [
      memory_usage: :erlang.memory(:total),
      process_count: :erlang.system_info(:process_count)
    ]
end
