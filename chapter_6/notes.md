### OTP behaviours

- https://hexdocs.pm/elixir/Module.html#module-behaviour
- http://erlang.org/doc/design_principles/des_princ.html
- OTP Behaviours: `:gen_server`, `:supervisor`, `:application`, `:gen_event`, `:gen_statem`
- Elixir Wrappers: `GenServer`, `Supervisor`, `Application`

### GenServer injection

```elixir
defmodule KeyValue do
  use GenServer
end

> KeyValue.__info__(:functions)
[
  child_spec: 1,
  code_change: 3,
  handle_call: 3,
  handle_cast: 2,
  handle_info: 2,
  init: 1,
  terminate: 2
]

> KeyValue.__info__(:attributes)
[vsn: [233447739398491185824333456879779831139], behaviour: [GenServer]]

> KeyValue.__info__(:compile)
[
  version: '7.6.6',
  options: [:no_spawn_compiler_process, :from_core, :no_core_prepare,
   :no_auto_import],
  source: '/home/user/code/elixir/in_action/iex'
]

> KeyValue.__info__(:macros)
[]

> KeyValue.__info__(:md5)
<<175, 160, 102, 48, 97, 11, 130, 241, 7, 114, 69, 53, 217, 175, 221, 99>>

> KeyValue.__info__(:module)
KeyValue

> KeyValue.__info__(:deprecated)
[]

> GenServer.start(KeyValue, nil)
{:ok, #PID<0.298.0>}
```

- https://hexdocs.pm/elixir/1.6.6/Module.html#__info__/1

###

```elixir

```

###

```elixir

```

###

```elixir

```
