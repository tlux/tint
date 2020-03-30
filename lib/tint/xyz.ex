defmodule Tint.XYZ do
  @moduledoc """
  A color in the XYZ (CIE 1931) colorspace.
  """
  @moduledoc since: "1.0.0"

  defstruct [:x, :y, :z]

  @type t :: %__MODULE__{x: Decimal.t(), y: Decimal.t(), z: Decimal.t()}

  @doc """
  Builds a new XYZ color using the lightness, a and b color channels.
  """
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
    |> Decimal.round(4)
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
