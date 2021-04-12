defmodule Todo.Cache.ClientTest do
  use ExUnit.Case, async: true

  alias Todo.Entry
  alias Todo.Cache.Client, as: CacheClient
  alias Todo.Server.Client, as: ServerClient

  describe "server_process/2" do
    test "should return the same pid for an existing list" do
      {:ok, cache} = CacheClient.start()
      bobs_pid = CacheClient.server_process(cache, "bob")

      assert bobs_pid != CacheClient.server_process(cache, "alice")
      assert bobs_pid == CacheClient.server_process(cache, "bob")
    end

    test "should allow todo operations on created server" do
      {:ok, cache} = CacheClient.start()
      alices_list = CacheClient.server_process(cache, "alice")
      ServerClient.add_entry(alices_list, %{date: ~D[2018-12-19], title: "Dentist"})
      entries = ServerClient.entries(alices_list, ~D[2018-12-19])

      assert [%Entry{date: ~D[2018-12-19], id: 1, title: "Dentist"}] = entries
    end
  end
end
