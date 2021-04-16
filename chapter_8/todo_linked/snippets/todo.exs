{:ok, supervisor_pid} = Todo.start_link()
Supervisor.count_children(supervisor_pid)
