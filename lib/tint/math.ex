defmodule Tint.Math do
  @moduledoc false

  @pi Decimal.from_float(:math.pi())

  @spec arctan(Decimal.decimal()) :: Decimal.t()
  def arctan(value) do
    decimal_as_float(value, &:math.atan/1)
  end

  @spec atan2(Decimal.decimal(), Decimal.decimal()) :: Decimal.t()
  def atan2(num1, num2) do
    num2 = num2 |> Decimal.new() |> Decimal.to_float()
    decimal_as_float(num1, &:math.atan2(&1, num2))
  end

  @spec cos(Decimal.decimal()) :: Decimal.t()
  def cos(value) do
    decimal_as_float(value, &:math.cos/1)
  end

  @spec exp(Decimal.decimal()) :: Decimal.t()
  def exp(value) do
    decimal_as_float(value, &:math.exp/1)
  end

  @spec ln(Decimal.decimal()) :: Decimal.t()
  def ln(value) do
    decimal_as_float(value, &:math.log/1)
  end

  @spec pi() :: Decimal.t()
  def pi, do: @pi

  @spec nth_root(Decimal.decimal(), integer) :: Decimal.t()
  def nth_root(value, n) do
    decimal_as_float(value, &nth_root_float(&1, n))
  end

  defp nth_root_float(x, n, precision \\ 1.0e-5) do
    f = fn prev -> ((n - 1) * prev + x / :math.pow(prev, n - 1)) / n end
    fixed_point(f, x, precision, f.(x))
  end

  defp fixed_point(_, guess, tolerance, next)
       when abs(guess - next) < tolerance,
       do: next

  defp fixed_point(f, _, tolerance, next) do
    fixed_point(f, next, tolerance, f.(next))
  end

  @spec pow(Decimal.decimal(), number) :: Decimal.t()
  def pow(value, 2) do
    Decimal.mult(value, value)
  end

  def pow(value, exp) do
    decimal_as_float(value, &:math.pow(&1, exp))
  end

  @spec rad_to_deg(Decimal.decimal()) :: Decimal.t()
  def rad_to_deg(value) do
    value =
      if Decimal.lt?(value, 0) do
        Decimal.add(value, Decimal.mult(2, @pi))
      else
        value
      end

    Decimal.mult(value, Decimal.div(180, @pi))
  end

  @spec deg_to_rad(Decimal.decimal()) :: Decimal.t()
  def deg_to_rad(value) do
    Decimal.mult(value, Decimal.div(@pi, 180))
  end

  @spec rem(Decimal.decimal(), Decimal.decimal()) :: Decimal.t()
  def rem(numerator, denominator) do
    {_, result} = Decimal.div_rem(numerator, denominator)
    result
  end

  @spec sin(Decimal.decimal()) :: Decimal.t()
  def sin(value) do
    decimal_as_float(value, &:math.sin/1)
  end

  defp decimal_as_float(value, fun) do
    value
    |> Decimal.new()
    |> Decimal.to_float()
    |> fun.()
    |> Decimal.from_float()
  end
end
