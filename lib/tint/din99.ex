defmodule Tint.DIN99 do
  @moduledoc """
  A color in the DIN99 colorspace.
  """
  @moduledoc since: "1.0.0"

  defstruct [:lightness, :a, :b]

  @type t :: %__MODULE__{
          lightness: Decimal.t(),
          a: Decimal.t(),
          b: Decimal.t()
        }

  @doc """
  Builds a new DIN99 color using the lightness, a and b color channels.
  """
  @spec new(
          float | Decimal.decimal(),
          float | Decimal.decimal(),
          float | Decimal.decimal()
        ) :: t
  def new(lightness, a, b) do
    %__MODULE__{
      lightness: cast_value(lightness),
      a: cast_value(a),
      b: cast_value(b)
    }
  end

  defp cast_value(value) do
    value
    |> Decimal.cast()
    |> Decimal.round(4)
  end

  @doc """
  Converts a tuple containing lightness, a and b into `Tint.DIN99` struct.
  """
  @spec from_tuple(
          {lightness :: float | Decimal.decimal(),
           a :: float | Decimal.decimal(), b :: float | Decimal.decimal()}
        ) :: t
  def from_tuple({lightness, a, b}) do
    new(lightness, a, b)
  end

  @doc """
  Converts a DIN99 color into a tuple containing the lightness, a and b
  channels.
  """
  @spec to_tuple(t) :: {Decimal.t(), Decimal.t(), Decimal.t()}
  def to_tuple(%__MODULE__{} = color) do
    {color.lightness, color.a, color.b}
  end

  defimpl Inspect do
    import Inspect.Algebra
    import Tint.Utils.Formatter

    def inspect(color, _opts) do
      concat([
        "#Tint.DIN99<",
        format_value(color.lightness),
        ",",
        format_value(color.a),
        ",",
        format_value(color.b),
        ">"
      ])
    end
  end
end
