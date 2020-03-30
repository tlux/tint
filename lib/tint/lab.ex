defmodule Tint.Lab do
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
  Calculates the distance of two colors using the CIEDE2000 algorithm. See
  `Tint.Distance.CIEDE2000` for more details.
  """
  @spec ciede2000_distance(t, Tint.color(), Keyword.t()) :: float
  def ciede2000_distance(%__MODULE__{} = color, other_color, opts \\ []) do
    Distance.distance(color, other_color, {Distance.CIEDE2000, opts})
  end

  @doc """
  Gets the nearest color from the given palette using the CIEDE2000 color
  distance algorithm.
  """
  @spec nearest_color(t, [Tint.color()], Distance.distance_calculator()) ::
          nil | Tint.color()
  def nearest_color(
        %__MODULE__{} = color,
        palette,
        distance_calculator \\ Distance.CIEDE2000
      ) do
    Distance.nearest_color(color, palette, distance_calculator)
  end

  @doc """
  Gets the n nearest colors from the given palette using the CIEDE2000 color
  distance algorithm.
  """
  @spec nearest_colors(
          t,
          [Tint.color()],
          non_neg_integer,
          Distance.distance_calculator()
        ) :: [Tint.color()]
  def nearest_colors(
        %__MODULE__{} = color,
        palette,
        n,
        distance_calculator \\ Distance.CIEDE2000
      ) do
    Distance.nearest_colors(color, palette, n, distance_calculator)
  end

  defimpl Inspect do
    import Inspect.Algebra
    import Tint.Utils.Formatter

    def inspect(color, _opts) do
      concat([
        "#Tint.Lab<",
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
