defmodule MyRegistryTest do
  use ExUnit.Case, async: true

  describe "register/1" do
    setup do
      MyRegistry.start_link()

      :ok
    end

    test "should register one pid per name" do
      assert MyRegistry.register(:me) == :ok
      assert MyRegistry.register(:me) == :error

      assert MyRegistry.register(:me_again) == :ok
      assert MyRegistry.register(:me_again) == :error
    end

    test "should return an error when name isn't and atom" do
      assert MyRegistry.register("BAD") == :error
      assert MyRegistry.register(123) == :error
      assert MyRegistry.register(%{a: "b"}) == :error
      assert MyRegistry.register(fn -> "garmonbozia" end) == :error
    end

    test "should automatically deregister process when it terminates" do
      {:ok, pid} = Agent.start_link(fn -> MyRegistry.register(:should_deregister) end)
      assert MyRegistry.whereis(:should_deregister) == pid
      Agent.stop(pid)
      Process.sleep(100)
      assert MyRegistry.whereis(:should_deregister) == nil
    end
  end

  describe "whereis/1" do
    setup do
      MyRegistry.start_link()

      :ok
    end

    test "should return registered pid" do
      MyRegistry.register(:me)

      assert MyRegistry.whereis(:me) == self()
      assert MyRegistry.whereis(:not_me) == nil
    end
  end

  describe "all/1" do
    setup do
      MyRegistry.start_link()

      :ok
    end

    test "should return all registered processes" do
      MyRegistry.register(:me)
      MyRegistry.register(:me_again)

      assert [{:me, self()}, {:me_again, self()}] == MyRegistry.all()
    end
  end
end
