defmodule Tint.HSV do
  @moduledoc """
  A color in the HSV (hue, saturation, value) colorspace.
  """

  import Tint.Utils

  alias Tint.Utils.Interval

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

    def inspect(color, _opts) do
      concat([
        "#Tint.HSV<",
        degrees_to_doc(color.hue),
        ",",
        percentage_to_doc(color.saturation),
        ",",
        percentage_to_doc(color.value),
        ">"
      ])
    end

    defp degrees_to_doc(value) do
      value
      |> Decimal.reduce()
      |> Decimal.to_string(:normal)
      |> Kernel.<>("°")
    end

    defp percentage_to_doc(value) do
      value
      |> Decimal.mult(100)
      |> Decimal.reduce()
      |> Decimal.to_string(:normal)
      |> Kernel.<>("%")
    end
  end

  defimpl Tint.HSV.Convertible do
    def to_hsv(hsv), do: hsv
  end

  defimpl Tint.RGB.Convertible do
    alias Tint.RGB
    alias Tint.Utils.Interval

    def to_rgb(hsv) do
      c = Decimal.mult(hsv.saturation, hsv.value)
      x = Decimal.mult(c, calc_x_part(hsv.hue))
      m = Decimal.sub(hsv.value, c)

      {red_ratio, green_ratio, blue_ratio} = calc_ratios(hsv.hue, c, x)

      red = calc_value(red_ratio, m)
      green = calc_value(green_ratio, m)
      blue = calc_value(blue_ratio, m)

      RGB.new(red, green, blue)
    end

    defp calc_value(ratio, m) do
      Decimal.round(Decimal.mult(Decimal.add(ratio, m), 255))
    end

    defp calc_ratios(hue, c, x) do
      cond do
        in_interval?(hue, 0, 60) -> {c, x, 0}
        in_interval?(hue, 60, 120) -> {x, c, 0}
        in_interval?(hue, 120, 180) -> {0, c, x}
        in_interval?(hue, 180, 240) -> {0, x, c}
        in_interval?(hue, 240, 300) -> {x, 0, c}
        in_interval?(hue, 300, 360) -> {c, 0, x}
      end
    end

    defp in_interval?(value, min, max) do
      min
      |> Interval.new(max, exclude_max: true)
      |> Interval.member?(value)
    end

    defp calc_x_part(hue) do
      Decimal.sub(
        1,
        Decimal.abs(Decimal.sub(Decimal.rem(Decimal.div(hue, 60), 2), 1))
      )
    end
  end
end
