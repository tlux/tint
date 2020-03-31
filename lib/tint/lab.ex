defmodule Tint.Lab do
  @moduledoc """
  A color in the CIELAB colorspace.
  """
  @moduledoc since: "1.0.0"

  import Tint.Utils.Cast

  alias Tint.Distance

  defstruct [:lightness, :a, :b]

  @type t :: %__MODULE__{
          lightness: float,
          a: float,
          b: float
        }

  @doc """
  Builds a new Lab color using the lightness, a and b color channels.
  """
  @spec new(number | String.t(), number | String.t(), number | String.t()) :: t
  def new(lightness, a, b) do
    %__MODULE__{
      lightness: cast_value!(lightness, :float),
      a: cast_value!(a, :float),
      b: cast_value!(b, :float)
    }
  end

  @doc """
  Converts a tuple containing lightness, a and b into `Tint.Lab` struct.
  """
  @spec from_tuple(
          {number | String.t(), number | String.t(), number | String.t()}
        ) :: t
  def from_tuple({lightness, a, b}) do
    new(lightness, a, b)
  end

  @doc """
  Converts a Lab color into a tuple containing the lightness, a and b channels.
  """
  @spec to_tuple(t) :: {float, float, float}
  def to_tuple(%__MODULE__{} = color) do
    {color.lightness, color.a, color.b}
  end

  @doc """
  Calculates the distance of two colors using the CIEDE2000 algorithm. See
  `Tint.Distance.CIEDE2000` for more details.
  """
  @spec ciede2000_distance(Tint.color(), Tint.color(), Keyword.t()) :: float
  def ciede2000_distance(color, other_color, opts \\ []) do
    Distance.distance(color, other_color, {Distance.CIEDE2000, opts})
  end

  @doc """
  Gets the nearest color from the given palette using the CIEDE2000 color
  distance algorithm.

  ## Options

  * `:weights` - A tuple defining the weights for the LCh color channels.
    Defaults to `{1, 1, 1}`.
  """
  @spec nearest_color(
          Tint.color(),
          [Tint.color()],
          Distance.distance_algorithm()
        ) :: nil | Tint.color()
  def nearest_color(
        color,
        palette,
        distance_algorithm \\ Distance.CIEDE2000
      ) do
    Distance.nearest_color(color, palette, distance_algorithm)
  end

  @doc """
  Gets the n nearest colors from the given palette using the CIEDE2000 color
  distance algorithm.
  """
  @spec nearest_colors(
          Tint.color(),
          [Tint.color()],
          non_neg_integer,
          Distance.distance_algorithm()
        ) :: [Tint.color()]
  def nearest_colors(
        color,
        palette,
        n,
        distance_algorithm \\ Distance.CIEDE2000
      ) do
    Distance.nearest_colors(color, palette, n, distance_algorithm)
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
