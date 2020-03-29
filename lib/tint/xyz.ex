defmodule Tint.XYZ do
  @moduledoc """
  A color in the CIE XYZ colorspace.
  """
  @moduledoc since: "0.4.0"

  defstruct [:x, :y, :z]

  @type t :: %__MODULE__{x: Decimal.t(), y: Decimal.t(), z: Decimal.t()}

  @spec new(
          float | Decimal.decimal(),
          float | Decimal.decimal(),
          float | Decimal.decimal()
        ) :: t
  def new(x, y, z) do
    %__MODULE__{x: cast_value(x), y: cast_value(y), z: cast_value(z)}
  end

  defp cast_value(value) do
    value
    |> Decimal.cast()
    |> Decimal.round(3)
  end

  defimpl Inspect do
    import Inspect.Algebra
    import Tint.Utils.Formatter

    def inspect(color, _opts) do
      concat([
        "#Tint.XYZ<",
        format_value(color.x),
        ",",
        format_value(color.y),
        ",",
        format_value(color.z),
        ">"
      ])
    end
  end
end
