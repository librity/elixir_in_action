MyRegistry.start_link()
MyRegistry.register("BAD")
MyRegistry.register(123)
MyRegistry.register(:some_process)
MyRegistry.register(:some_process)
MyRegistry.whereis(:some_process)
MyRegistry.whereis(:unregistered_process)
MyRegistry.all()

spawn(fn ->
  MyRegistry.register(:should_deregister)
  pid = MyRegistry.whereis(:should_deregister)
  IO.puts("Registered spawn with #{inspect(pid)}")

  Process.sleep(2000)
  raise("Something went wrong")
end)

MyRegistry.whereis(:should_deregister)
MyRegistry.all()
