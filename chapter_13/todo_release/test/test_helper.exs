ExUnit.start()

ExUnit.after_suite(fn _ ->
  Application.fetch_env!(:todo, :database)
  |> Keyword.fetch!(:db_folder)
  |> File.rm_rf!()
end)
