defmodule Tint.CMYK do
  @moduledoc """
  A color in the CMYK (cyan, magenta, yellow, key) colorspace.
  """
  @moduledoc since: "0.3.0"

  import Tint.Utils.Cast

  defstruct [:cyan, :magenta, :yellow, :key]

  @type t :: %__MODULE__{
          cyan: float,
          magenta: float,
          yellow: float,
          key: float
        }

  @doc """
  Builds a new CMYK color from cyan, magenta, yellow and key color parts. Please
  always use this function to build a new CMYK color.

  ## Examples

      iex> Tint.CMYK.new(0.06, 0.32, 0.8846, 0.23)
      #Tint.CMYK<6.0%,32.0%,88.46%,23.0%>

      iex> Tint.CMYK.new(0.06, 3.2, 0.8846, 0.23)
      ** (Tint.OutOfRangeError) Value 3.2 is out of range [0,1]
  """
  @spec new(
          number | String.t(),
          number | String.t(),
          number | String.t(),
          number | String.t()
        ) :: t
  def new(cyan, magenta, yellow, key) do
    %__MODULE__{
      cyan: cast_ratio!(cyan),
      magenta: cast_ratio!(magenta),
      yellow: cast_ratio!(yellow),
      key: cast_ratio!(key)
    }
  end

  @doc """
  Converts a tuple containing cyan, magenta, yellow and key color parts into a
  `Tint.CMYK` struct.
  """
  @spec from_tuple(
          {number | String.t(), number | String.t(), number | String.t(),
           number | String.t()}
        ) :: t
  def from_tuple({cyan, magenta, yellow, key}) do
    new(cyan, magenta, yellow, key)
  end

  @doc """
  Converts CMYK color into a tuple containing the cyan, magenta, yellow and key
  parts.
  """
  @spec to_tuple(t) :: {float, float, float, float}
  def to_tuple(%__MODULE__{} = color) do
    {color.cyan, color.magenta, color.yellow, color.key}
  end

  defimpl Inspect do
    import Inspect.Algebra
    import Tint.Utils.Formatter

    def inspect(color, _opts) do
      concat([
        "#Tint.CMYK<",
        format_percentage(color.cyan),
        ",",
        format_percentage(color.magenta),
        ",",
        format_percentage(color.yellow),
        ",",
        format_percentage(color.key),
        ">"
      ])
    end
  end
end
