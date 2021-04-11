### Bash

```bash
# Compile and load on memory (no .beam file saved to disk)
$ iex my_module.ex
# Compile in memory and run
$ elixir my_script.exs
# When script starts concurrent tasks
# and you don't want to terminate the BEAM instance
$ elixir --no-halt script.exs
# Compile to .beam file
$ elixirc my_module.ex
# Add .beam files to path
$ iex -pa my/code/path -pa another/code/path
```

### Mix

```elixir
$ mix compile
$ mix format mix.exs "lib/**/*.{ex,exs}" "test/**/*.{ex,exs}"
$ mix run -e "IO.puts(MyProject.hello())"
world
```

- https://hexdocs.pm/mix/Mix.Tasks.Format.html

### Kernel

```elixir
# Get all .beam paths
> :code.get_path
['/usr/lib/elixir/bin/../lib/mix/ebin',
 '/usr/lib/elixir/bin/../lib/logger/ebin',
 ...]
# Politely exit iex
> System.halt
# IEx module orchestrates the Elixir shell
> h IEx
# All alias are secretly prefixed with `Elixir.`
> AnAtom == :"Elixir.AnAtom"
true
# Short-circuit operator
> nil || false || 5 || true
5
# MFA (module, function, arguments)
> apply(IO, :puts, ["Dynamic function call."])
Dynamic function call.
```

- https://hexdocs.pm/elixir/master/Kernel.html
- https://hexdocs.pm/iex/IEx.html
- https://hexdocs.pm/elixir/master/Integer.html
- https://hexdocs.pm/elixir/Kernel.SpecialForms.html

### Tuples

```elixir
# Get element of a tuple by index
> person = {"Bob", 25}
> age = elem(person, 1)
25
# Create a new, modified tuple
> put_elem(person, 1, 26)
{"Bob", 26}
```

### Lists

```bash
# Lists are exaclty like Linked Lists in your libft
> length([1,2,3,4,5])
5
> 5 in [1,2,3,4,5]
true
# List append is expensive, especially at the end
> List.insert_at(prime_numbers, -1, 13)
[11, 3, 5, 7, 13]
# Very inefficien too
> [1, 2, 3] ++ [4, 5]
[1, 2, 3, 4, 5]

# Lists are most efficient when new elements are pushed
# to top or popped from the top:
> a_list = [5, :value, true]
[5, :value, true]
> new_list = [:new_element | a_list]
[:new_element, 5, :value, true]

> [1 | []]
[1]
> [1 | [2 | []]]
[1, 2]
> [1 | [2]]
[1, 2]
> [1 | [2, 3, 4]]
[1, 2, 3, 4]
> [1 | [2 | [3 | [4 | []]]]]
[1, 2, 3, 4]
> hd([1, 2, 3, 4])
1
> tl([1, 2, 3, 4])
[2, 3, 4]
```

- https://hexdocs.pm/elixir/List.html

### Maps

```elixir
> squares = Map.new([{1, 1}, {2, 4}, {3, 9}])
%{1 => 1, 2 => 4, 3 => 9}
> %{bob | age: 26, works_at: "Initrode"}
%{age: 26, name: "Bob", works_at: "Initrode"}
```

### Binaries and bitstrings

```elixir
> <<1, 2, 3>>
<<1, 2, 3>>
> <<256>>
<<0>>
> <<257>>
<<1>>
> <<512>>
<<0>>
> <<257::16>>
<<1, 1>>
> <<1::4, 15::4>>
<<31>>
> <<1::1, 0::1, 1::1>>
<<5::size(3)>>
> <<1, 2>> <> <<3, 4>>
<<1, 2, 3, 4>>
```

### Strings

```elixir
> ~s("Do... or do not. There is no try." -Master Yoda)
"\"Do... or do not. There is no try.\" -Master Yoda"
> ~S(Not interpolated #{3 + 0.14}\n)
"Not interpolated \#{3 + 0.14}\\n
> """
			Heredoc must end on its own line """
	"""
"Heredoc must end on its own line \"\"\"\n""
> "String" <> " " <> "concatenation"
"String concatenation"
```

- https://hexdocs.pm/elixir/String.html

### Character lists

```elixir
> 'ABC'
'ABC'
> [65, 66, 67]
'ABC'
> 'Interpolation: #{3 + 0.14}'
'Interpolation: 3.14'
> ~c(Character list sigil)
'Character list sigil'
> ~C(Unescaped sigil #{3 + 0.14})
'Unescaped sigil \#{3 + 0.14}'
> '''
		Heredoc
	'''
'Heredoc\n'
> String.to_charlist("ABC")
'ABC'
> List.to_string('ABC')
"ABC"
```

### First-class functions

```elixir
> square = fn x -> x * x end
> square.(5)
25
# Capture operator &
> lambda_one = fn x, y, z -> x * y + z end
> lambda_two = &(&1 * &2 + &3)
> lambda_one == lambda_two
# Closures
> outside_var = 5
> lambda = fn -> IO.puts(outside_var) end
> outside_var = 6
> lambda.()
5
```

### Misc Types

```elixir
# A reference is a unique identifier for something
> Kernel.make_ref()
#Reference<0.1739961257.745275395.250636>
# Ranges take veery little memory
> Enum.each(1..3, &IO.puts/1)
1 2 3
# Keyword lists are variable-size maps (not as efficient)
> days = [monday: 1, tuesday: 2, wednesday: 3]
> Keyword.get(days, :monday)
1
# Usually used to pass options to a function
> IO.inspect([100, 200, 300], width: 3, limit: 1)
[100, ...]
```

- https://hexdocs.pm/elixir/Enum.html
- https://hexdocs.pm/elixir/Keyword.html

### MapSets

```elixir
> days = MapSet.new([:monday, :tuesday, :wednesday])
#MapSet<[:monday, :tuesday, :wednesday]>
> MapSet.member?(days, :monday)
true
> MapSet.member?(days, :noday)
false
> days = MapSet.put(days, :thursday)
#MapSet<[:monday, :thursday, :tuesday, :wednesday]>
```

- https://hexdocs.pm/elixir/MapSet.html

### Date, Time and misc

```elixir
> date = ~D[2018-01-31]
~D[2018-01-31]
> date.year
2018
> time = ~T[11:59:12.00007]
> time.hour
11
> naive_datetime = ~N[2018-01-31 11:59:12.000007]
> naive_datetime.year
2018
> datetime = DateTime.from_naive!(naive_datetime, "Etc/UTC")
> datetime.year
2018
> datetime.hour
11
> datetime.time_zone
"Etc/UTC"
```

### IOLists

```elixir
# IOLists appending is O(1)
> iolist = []
	iolist = [iolist, "This"]
	iolist = [iolist, " is"]
	iolist = [iolist, " an"]
	iolist = [iolist, " IO list."]
[[[[[], "This"], " is"], " an"], " IO list."]
# It automatically gets flattened when called
> IO.puts(iolist)
This is an IO list.
```

### Operators

```elixir
# Elixir has strict equality
> 1 == 1.0
true
> 1 === 1.0
false
```

### Specs

```elixir
# Specify the types of a function's arguments return w/ @spec
defmodule Circle do
  @pi 3.14159

  @spec area(number) :: number
  def area(r), do: r*r*@pi

  @spec circumference(number) :: number
  def circumference(r), do: 2*r*@pi
end
```

- https://hexdocs.pm/elixir/typespecs.html
- https://hexdocs.pm/elixir/Module.html

### Scripts

```elixir
defmodule MyModule do
	def run do
    IO.puts("Called MyModule.run")
  end
end

MyModule.run
```

- https://elixirschool.com/en/lessons/advanced/escripts/
