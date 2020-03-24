defmodule Tint.HSV do
  @moduledoc """
  A color in the HSV (hue, saturation, value) colorspace.
  """

  import Tint.Utils

  defstruct [:hue, :saturation, :value]

  @type t :: %__MODULE__{
          hue: Decimal.t(),
          saturation: Decimal.t(),
          value: Decimal.t()
        }

  @doc """
  Builds a new HSV color from hue, saturation and value color parts. Please
  always use this function to build a new HSV color.

  ## Examples

      iex> Tint.HSV.new(25.8, 0.882, 1)
      #Tint.HSV<25.8°,88.2%,100%>
  """
  @spec new(Decimal.t() | number, Decimal.t() | number, Decimal.t() | number) ::
          t
  def new(hue, saturation, value) do
    with {:ok, hue} <- cast_degrees(hue),
         {:ok, saturation} <- cast_ratio(saturation),
         {:ok, value} <- cast_ratio(value) do
      %__MODULE__{hue: hue, saturation: saturation, value: value}
    else
      {:error, error} -> raise error
    end
  end

  @doc """
  Converts a tuple containing hue, saturation and value into a `Tint.HSV`
  struct.
  """
  @spec from_tuple(
          {Decimal.t() | number, Decimal.t() | number, Decimal.t() | number}
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
    {Decimal.to_float(color.hue), Decimal.to_float(color.saturation),
     Decimal.to_float(color.value)}
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
  end
end
