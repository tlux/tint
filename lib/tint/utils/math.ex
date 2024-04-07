defmodule Tint.Utils.Math do
  @moduledoc false

  @spec root(number, integer) :: float
  def root(value, n) when n > 0 do
    :math.pow(value, 1.0 / n)
  end

  @spec rad_to_deg(float) :: float
  def rad_to_deg(value) do
    pi = :math.pi()

    value =
      if value < 0 do
        value + 2 * pi
      else
        value
      end

    value * (180 / pi)
  end

  @spec deg_to_rad(float) :: float
  def deg_to_rad(value) do
    value * (:math.pi() / 180)
  end

  def rem(dividend, divisor) when is_float(dividend) and is_integer(divisor) do
    int_dividend = abs(floor(dividend))
    rest = Kernel.rem(int_dividend, divisor)
    decimal_rest = dividend - int_dividend
    rest + decimal_rest
  end
end
