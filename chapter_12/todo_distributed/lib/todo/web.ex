defmodule Todo.Web do
  use Plug.Router

  alias Todo.Cache.Client, as: CacheClient
  alias Todo.Server.Client, as: ServerClient

  plug(:match)
  plug(:dispatch)

  def child_spec(_) do
    Plug.Adapters.Cowboy.child_spec(
      scheme: :http,
      options: [port: fetch_port()],
      plug: __MODULE__
    )
  end

  defp fetch_port, do: Application.fetch_env!(:todo, :port)

  get "/entries" do
    conn = Plug.Conn.fetch_query_params(conn)
    list_name = Map.fetch!(conn.params, "list")
    date = conn.params |> Map.fetch!("date") |> Date.from_iso8601!()

    entries =
      list_name
      |> CacheClient.server_process()
      |> ServerClient.entries(date)

    formatted_entries =
      entries
      |> Stream.map(&"#{&1.date} #{&1.title}")
      |> Enum.join("\n")

    conn
    |> Plug.Conn.put_resp_content_type("text/plain")
    |> Plug.Conn.send_resp(200, formatted_entries)
  end

  post "/add_entry" do
    conn = Plug.Conn.fetch_query_params(conn)
    list_name = Map.fetch!(conn.params, "list")
    title = Map.fetch!(conn.params, "title")
    date = conn.params |> Map.fetch!("date") |> Date.from_iso8601!()

    list_name
    |> CacheClient.server_process()
    |> ServerClient.add_entry(%{title: title, date: date})

    conn
    |> Plug.Conn.put_resp_content_type("text/plain")
    |> Plug.Conn.send_resp(200, "OK")
  end
end
