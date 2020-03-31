defmodule Tint.DIN99 do
  @moduledoc """
  A color in the DIN99 colorspace.
  """
  @moduledoc since: "1.0.0"

  import Tint.Utils.Cast

  defstruct [:lightness, :a, :b]

  @type t :: %__MODULE__{
          lightness: float,
          a: float,
          b: float
        }

  @doc """
  Builds a new DIN99 color using the lightness, a and b color channels.
  """
  @spec new(number, number, number) :: t
  def new(lightness, a, b) do
    %__MODULE__{
      lightness: cast_value!(lightness, :float),
      a: cast_value!(a, :float),
      b: cast_value!(b, :float)
    }
  end

  @doc """
  Converts a tuple containing lightness, a and b into `Tint.DIN99` struct.
  """
  @spec from_tuple({number, number, number}) :: t
  def from_tuple({lightness, a, b}) do
    new(lightness, a, b)
  end

  @doc """
  Converts a DIN99 color into a tuple containing the lightness, a and b
  channels.
  """
  @spec to_tuple(t) :: {float, float, float}
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
