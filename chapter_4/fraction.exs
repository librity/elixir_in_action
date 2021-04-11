defmodule Fraction do
  defstruct num: nil, deno: nil

  def new(numerator, denominator), do: %__MODULE__{num: numerator, deno: denominator}

  def value(%__MODULE__{num: numerator, deno: denominator}), do: numerator / denominator

  def add(%__MODULE__{} = left, %__MODULE__{} = right),
    do: new(left.num * right.deno + right.num * left.deno, left.deno * right.deno)
end

one_half = %Fraction{num: 1, deno: 2}
one_half.num
one_half.deno
one_quarter = %Fraction{one_half | deno: 4}

operation = Fraction.add(one_half, one_quarter)
Fraction.value(operation)

operation = Fraction.add(Fraction.new(1, 2), Fraction.new(1, 4))
Fraction.value(operation)
