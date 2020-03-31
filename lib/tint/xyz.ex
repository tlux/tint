defmodule Tint.XYZ do
  @moduledoc """
  A color in the XYZ (CIE 1931) colorspace.
  """
  @moduledoc since: "1.0.0"

  import Tint.Utils.Cast

  defstruct [:x, :y, :z]

  @type t :: %__MODULE__{x: float, y: float, z: float}

  @doc """
  Builds a new XYZ color using the lightness, a and b color channels.
  """
  @spec new(number | String.t(), number | String.t(), number | String.t()) :: t
  def new(x, y, z) do
    %__MODULE__{
      x: cast_value!(x, :float),
      y: cast_value!(y, :float),
      z: cast_value!(z, :float)
    }
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
