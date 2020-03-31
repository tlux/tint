defmodule Tint.HSV do
  @moduledoc """
  A color in the HSV (hue, saturation, value) colorspace.
  """

  import Tint.Utils.Cast

  alias Tint.Utils.Interval

  defstruct [:hue, :saturation, :value]

  @type t :: %__MODULE__{
          hue: float,
          saturation: float,
          value: float
        }

  @hue_interval Interval.new(0, 360)
  @hue_excl_interval %{@hue_interval | exclude_max: true}

  @doc """
  Builds a new HSV color from hue, saturation and value color parts. Please
  always use this function to build a new HSV color.

  ## Examples

      iex> Tint.HSV.new(25.8, 0.882, 1)
      #Tint.HSV<25.8°,88.2%,100%>
  """
  @spec new(number | String.t(), number | String.t(), number | String.t()) :: t
  def new(hue, saturation, value) do
    %__MODULE__{
      hue: cast_value_with_interval!(hue, :float, @hue_excl_interval),
      saturation: cast_ratio!(saturation),
      value: cast_ratio!(value)
    }
  end

  @doc """
  Converts a tuple containing hue, saturation and value into a `Tint.HSV`
  struct.
  """
  @spec from_tuple(
          {number | String.t(), number | String.t(), number | String.t()}
        ) :: t
  def from_tuple({hue, saturation, value}) do
    new(hue, saturation, value)
  end

  @doc """
  Converts HSV color into a tuple containing the hue, saturation and value
  parts.
  """
  @spec to_tuple(t) :: {float, float, float}
  def to_tuple(%__MODULE__{} = color) do
    {color.hue, color.saturation, color.value}
  end

  @doc """
  Determines whether the given color is a grayscale color which basically means
  that saturation or the value is 0.
  """
  @doc since: "1.0.0"
  @spec grayscale?(t) :: boolean
  def grayscale?(%__MODULE__{} = color) do
    color.saturation == 0 || color.value == 0
  end

  @doc """
  Checks whether the hue of the given color is in the specified bounds. This
  can be used to cluster colors by their chromaticity.
  """
  @doc since: "1.0.0"
  @spec hue_between?(t, min :: number, max :: number) :: boolean
  def hue_between?(%__MODULE__{} = color, min, max) when min <= max do
    color.hue >= min && color.hue < max
  end

  defimpl Inspect do
    import Inspect.Algebra
    import Tint.Utils.Formatter

    def inspect(color, _opts) do
      concat([
        "#Tint.HSV<",
        format_degrees(color.hue),
        ",",
        format_percentage(color.saturation),
        ",",
        format_percentage(color.value),
        ">"
      ])
    end

    defp format_degrees(value) do
      format_value(value) <> "°"
    end
  end
end
