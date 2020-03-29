defmodule Tint.CIELAB do
  @moduledoc """
  A color in the CIELAB colorspace.
  """
  @moduledoc since: "0.4.0"

  defstruct [:lightness, :a, :b]

  alias Tint.Distance

  @type t :: %__MODULE__{
          lightness: Decimal.t(),
          a: Decimal.t(),
          b: Decimal.t()
        }

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

  @spec from_tuple(
          {lightness :: float | Decimal.decimal(),
           a :: float | Decimal.decimal(), b :: float | Decimal.decimal()}
        ) :: t
  def from_tuple({lightness, a, b}) do
    new(lightness, a, b)
  end

  @spec to_tuple(t) :: {Decimal.t(), Decimal.t(), Decimal.t()}
  def to_tuple(%__MODULE__{} = color) do
    {color.lightness, color.a, color.b}
  end

  @doc """
  Implements the CIEDE2000 color distance algorithm as described here:
  http://www2.ece.rochester.edu/~gsharma/ciede2000/ciede2000noteCRNA.pdf
  """
  @spec ciede2000_distance(t, Tint.color(), Keyword.t()) :: float
  def ciede2000_distance(%__MODULE__{} = color, other_color, opts \\ []) do
    Distance.CIEDE2000.ciede2000_distance(color, other_color, opts)
  end

  @spec nearest_color(t, [Tint.color()]) :: nil | Tint.color()
  def nearest_color(%__MODULE__{} = color, palette) do
    Distance.nearest_color(color, palette, &ciede2000_distance/2)
  end

  @spec nearest_colors(t, [Tint.color()], non_neg_integer) :: [Tint.color()]
  def nearest_colors(%__MODULE__{} = color, palette, n) do
    Distance.nearest_colors(color, palette, n, &ciede2000_distance/2)
  end

  defimpl Inspect do
    import Inspect.Algebra
    import Tint.Utils.Formatter

    def inspect(color, _opts) do
      concat([
        "#Tint.CIELAB<",
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
