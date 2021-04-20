bobs_list = Todo.Cache.Client.server_process("bobs_list")
Process.alive?(bobs_list)
Process.sleep(:timer.seconds(11))
Process.alive?(bobs_list)
