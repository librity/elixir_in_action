### Patter Matching

```elixir
> {date, time} = :calendar.local_time()
> {year, month, day} = date
> {hour, minute, second} = time
> {_, {hour, _, _}} = :calendar.local_time()
> {amount, amount, amount} = {127, 127, 127}
{127, 127, 127}
> {amount, amount, amount} = {127, 127, 1}
** (MatchError) no match of right hand side value: {127, 127, 1}
# Inefficient way of getting the min value of a list
> [min | _tails] = Enum.sort([3,2,1])
> min
1
> [_, {name, _}, _] = [{"Bob", 25}, {"Alice", 30}, {"John", 35}]
```

- https://hexdocs.pm/elixir/master/patterns-and-guards.html

### Pin Operator

```elixir
> expected_name = "Bob"
"Bob"
> {^expected_name, _} = {"Bob", 25}
{"Bob", 25}
> {^expected_name, _} = {"Alice", 30}
** (MatchError) no match of right hand side value: {"Alice", 30}
```

### Matching bitstrings and binaries

```elixir
> binary = <<1, 2, 3>><<1, 2, 3>>
> <<b1, b2, b3>> = binary
<<1, 2, 3>>
> b2
2
> <<b1, rest :: binary>> = binary
<<1, 2, 3>>
> b1
1
> rest
<<2, 3>>
# You can split bytes into lower and higher bits:
# 155 = 10011011; 9 = 1001; 11 = 1011
> <<a :: 4, b :: 4>> = << 155 >>
<< 155 >>
> a
9
> b
11
```

### Matching binary strings

```elixir
# Better use the String module for String matching
> <<b1, b2, b3>> = "ABC"
"ABC"
> b1
65
> b2
66
> command = "ping www.example.com"
> "ping " <> url = command
"ping www.example.com"
> url
"www.example.com"
```

### Compound matches

```elixir
> a = (b = 1 + 3)
4
> a = b = 1 + 3
4
> date_time = {_, {hour, _, _}} = :calendar.local_time()
> {_, {hour, _, _}} = date_time = :calendar.local_time()
> date_time
{{2018, 11, 11}, {21, 32, 34}}
> hour
21
```

### Multiclause function

```elixir

defmodule Geometry do
  def area({:rectangle, a, b}), do: a * b
  def area({:square, a}), do: a * a
  def area({:circle, r}), do: r * r * 3.14
  def area(unknown), do: {:error, {:unknown_shape, unknown}}
end

> Geometry.area({:rectangle, 4, 5})
20
> Geometry.area({:square, 5})
25
> Geometry.area({:circle, 4})
50.24
> Geometry.area({:triangle, 1, 2, 3})
{:error, {:unknown_shape, {:triangle, 1, 2, 3}}}

> fun = &Geometry.area/1
> fun.({:circle, 4})
50.24
> fun.({:square, 5})
25
```

### Guards

```elixir
defmodule TestNum do
  def test(x) when is_number(x) and x < 0, do: :negative
  def test(0), do: :zero
  def test(x) when is_number(x) and x > 0, do: :positive
end

> TestNum.test(-1)
:negative
> TestNum.test(0)
:zero
> TestNum.test(1)
:positive
> TestNum.test(:not_a_number)
** (FunctionClauseError) no function clause matching in TestNum.test/1

defmodule ListHelper do
  def smallest(list) when length(list) > 0, do: Enum.min(list)
  def smallest(_), do: {:error, :invalid_argument}
end

> ListHelper.smallest([123, 4, 9])
> ListHelper.smallest(123)
```

- https://hexdocs.pm/elixir/guards.html

Operators allowed in Guard:

- `==, !=, ===, !==, >, <, <=, >=`
- `and, or, not, !`
- `+, -, *, /`
- `Kernel.is_number/1`, `Kernel.is_atom/1`, etc.

### Type-order hierarchy

```elixir
number < atom < reference < fun < port < pid <  tuple < map < list < bitstring (binary)
```

### Multiclause lambdas

```elixir
test_num = fn
  x when is_number(x) and x < 0 ->
    :negative

  0 ->
    :zero

  x when is_number(x) and x > 0 ->
    :positive
end

> test_num.(-1)
:negative
> test_num.(0)
:zero
> test_num.(1)
:positive
```

### Branching with multiclause functions

```elixir
defmodule TestList do
  def empty?([]), do: true
  def empty?([_ | _]), do: false
end
```

```elixir
defmodule Polymorphic do
  def double(x) when is_number(x), do: 2 * x
  def double(x) when is_binary(x), do: x <> x
end

> Polymorphic.double(3)
6
> Polymorphic.double("Jar")
"JarJar"
```

```elixir
defmodule Fact do
  def fact(0), do: 1
  def fact(n), do: n * fact(n - 1)
end

> Fact.fact(1)
1
> Fact.fact(3)
6
```

```elixir
defmodule ListHelper do
  def sum([]), do: 0
  def sum([head | tail]), do: head + sum(tail)
end

> ListHelper.sum([])
0
> ListHelper.sum([1, 2, 3])
6
```

### if and unless

```elixir
if condition, do: something, else: another_thing

> if 5 > 3, do: :one
:one
> if 5 < 3, do: :one
nil
> if 5 < 3, do: :one, else: :two
:two

def max(a, b) do
  if a >= b, do: a, else: b
end

def max(a, b) do
  unless a >= b, do: b, else: a
end
```

### cond

```elixir
def max(a, b) do
  cond do
    a >= b -> a
    true -> b
  end
end
```

### case

```elixir
def max(a, b) do
  case a >= b do
    true -> a
    false -> b
  end
end
```

### **_with_**

```elixir
defmodule UserExtraction do
  def extract_user(user) do
    with {:ok, login} <- extract_login(user),
         {:ok, email} <- extract_email(user),
         {:ok, password} <- extract_password(user) do
      {:ok, %{login: login, email: email, password: password}}
    end
  end
end

> UserExtraction.extract_user(%{})
{:error, "login missing"}
> UserExtraction.extract_user(%{"login" => "some_login"})
{:error, "email missing"}
> UserExtraction.extract_user(%{"login" => "some_login", "email" => "some_email"})
{:error, "password missing"}
> UserExtraction.extract_user(%{
    "login" => "some_login",
    "email" => "some_email",
    "password" => "some_password"
  })
{:ok, %{email: "some_email", login: "some_login", password: "some_password"}}
```

### Iterating with recursion

```elixir
defmodule NaturalNums do
  def print(number) when is_float(number), do: number |> trunc() |> print()

  def print(0), do: IO.puts(0)

  def print(number) when number > 0 do
    print(number - 1)
    IO.puts(number)
  end

  def print(number) when number < 0 do
    print(number + 1)
    IO.puts(number)
  end
end

> NaturalNums.print(3)
> NaturalNums.print(-3)
> NaturalNums.print(3.4)
> NaturalNums.print(-3.4)
```

- https://hexdocs.pm/elixir/master/Kernel.html#is_float/1
- https://stackoverflow.com/questions/55580230/what-is-the-best-way-to-round-a-float-in-elixir
- https://stackoverflow.com/questions/48233043/how-do-i-convert-an-float-to-an-integer-in-elixir

### Tail-call optimization

```elixir
defmodule ListHelper do
  def sum(list), do: recurse_sum(0, list)

  defp recurse_sum(current_sum, []), do: current_sum
  defp recurse_sum(current_sum, [head | tail]), do: (head + current_sum) |> recurse_sum(tail)
end

> ListHelper.sum([1, 2, 3])
6
> ListHelper.sum([])
0
```

```elixir
defmodule ListLength do
  def call(list), do: recurse_list_length(list, 0)
  defp recurse_list_length([], length), do: length
  defp recurse_list_length([_head | tails], length), do: tails |> recurse_list_length(length + 1)
end

> ListLength.call([1, 2, 3, 4, 5])
> ListLength.call([1])
> ListLength.call([])
```

```elixir
defmodule ListRange do
  def call(from, to), do: recurse_range(from, to, [])
  defp recurse_range(from, to, result) when from > to, do: result
  defp recurse_range(from, to, result), do: recurse_range(from, to - 1, [to | result])
end

> ListRange.call(4, 10)
> ListRange.call(-12, 10)
> ListRange.call(-12, 8)
> ListRange.call(3, 3)
```

```elixir
defmodule ListPositive do
  def call(list), do: filter_positive(list, [])
  defp filter_positive([], result), do: Enum.reverse(result)

  defp filter_positive([head | tails], result) when head > 0,
    do: filter_positive(tails, [head | result])

  defp filter_positive([head | tails], result), do: filter_positive(tails, result)
end

> ListPositive.call([1, 3, -45, 0, 4, 5])
> ListPositive.call([1, -3, 4, -5])
> ListPositive.call([1, 4, 12, 2, -3])
> ListPositive.call([-1, -4, -12, -2, -3])
```

### Higher-order functions

```elixir
> Enum.map([1, 2, 3], &(2 * &1))
> Enum.filter([1, 2, 3], &(rem(&1, 2) == 1))

> Enum.reduce([1, 2, 3], 0, &(&1 + &2))
> Enum.reduce([1,2,3], 0, &+/2)
> Enum.sum([1, 2, 3])
> Enum.sum([1, "not a number", 2, :x, 3])
```

```elixir
> Enum.reduce(
  [1, "not a number", 2, :x, 3],
  0,
  fn
    element, sum when is_number(element) ->
      sum + element

    _, sum ->
      sum
  end
)
```

```elixir
defmodule NumHelper do
  def sum_nums(enumerable), do: Enum.reduce(enumerable, 0, &add_num/2)
  defp add_num(num, sum) when is_number(num), do: sum + num
  defp add_num(_, sum), do: sum
end

> NumHelper.sum_nums([1, "not a number", 2, :x, 3])
```

```elixir
defmodule UserExtraction do
  def extract_user(user) do
    case Enum.filter(
           ["login", "email", "password"],
           &(not Map.has_key?(user, &1))
         ) do
      [] ->
        {:ok,
         %{
           login: user["login"],
           email: user["email"],
           password: user["password"]
         }}

      missing_fields ->
        {:error, "missing fields: #{Enum.join(missing_fields, ", ")}"}
    end
  end
end

> UserExtraction.extract_user(%{})
{:error, "missing fields: login, email, password"}
> UserExtraction.extract_user(%{"login" => "some_login"})
{:error, "missing fields: email, password"}
> UserExtraction.extract_user(%{"login" => "some_login", "email" => "some_email"})
{:error, "missing fields: password"}
> UserExtraction.extract_user(%{
  "login" => "some_login",
  "email" => "some_email",
  "password" => "some_password"
})
{:ok, %{email: "some_email", login: "some_login", password: "some_password"}}
```

- https://hexdocs.pm/elixir/Enum.html

### Comprehensions

```elixir
> for x <- [1, 2, 3], do: x * x
[1, 4, 9]
> for x <- [1, 2, 3], y <- [1, 2, 3], do: {x, y, x * y}
> for x <- 1..9, y <- 1..9, do: {x, y, x * y}
```

```elixir
> multiplication_table = for x <- 1..9, y <- 1..9, into: %{}, do: {{x, y}, x * y}
> multiplication_table[{7, 6}]
42
```

```elixir
> multiplication_table =
  for x <- 1..9, y <- 1..9, x <= y, into: %{} do
    {{x, y}, x * y}
  end

> multiplication_table[{6, 7}]
42
> multiplication_table[{7, 6}]
nil
```

- https://hexdocs.pm/elixir/Kernel.SpecialForms.html#for/1

### Streams

Lazy, lazy, lazy...

```elixir
> [1, 2, 3] |>
Stream.map(fn x -> 2 * x end) |>
Enum.take(2)
[2, 4]

> ["Alice", "Bob", "John"] |>
Stream.with_index() |>
Enum.each(fn {employee, index} -> IO.puts("#{index + 1}. #{employee}") end)

> [9, -1, "foo", 25, 49, 49.0, 32.3, 32] |>
Stream.filter(&(is_number(&1) and &1 > 0)) |>
Stream.map(&{&1, :math.sqrt(&1)}) |>
Stream.with_index() |>
Enum.each(fn {{input, result}, index} ->
  IO.puts("#{index + 1}. sqrt(#{input}) = #{result}")
end)
```

```elixir
defmodule FileUtils do
  def large_lines!(path) do
    path
    |> lines_stream!()
    |> Enum.filter(&(String.length(&1) > 80))
  end

  def lines_lengths!(path) do
    path
    |> lines_stream!()
    |> Enum.map(&String.length/1)
  end

  def longest_line_length!(path) do
    path
    |> lines_stream!()
    |> Stream.map(&String.length/1)
    |> Enum.max()
  end

  def longest_line!(path) do
    path
    |> lines_stream!()
    |> Enum.max_by(&String.length/1)
  end

  def words_per_line!(path) do
    path
    |> lines_stream!()
    |> Enum.map(&count_words/1)
  end

  defp lines_stream!(path) do
    path
    |> File.stream!()
    |> Stream.map(&String.replace(&1, "\n", ""))
  end

  defp count_words(string) do
    string
    |> String.split()
    |> length()
  end
end

> FileUtils.large_lines!("./elixir_in_action/chapter_3/notes.md")
> FileUtils.lines_lengths!("./elixir_in_action/chapter_3/notes.md")
> FileUtils.longest_line_length!("./elixir_in_action/chapter_3/notes.md")
> FileUtils.longest_line!("./elixir_in_action/chapter_3/notes.md")
> FileUtils.words_per_line!("./elixir_in_action/chapter_3/notes.md")
```

- https://hexdocs.pm/elixir/Stream.html
