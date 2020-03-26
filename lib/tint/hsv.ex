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
  @spec new(
          float | Decimal.decimal(),
          float | Decimal.decimal(),
          float | Decimal.decimal()
        ) :: t
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
          {hue :: float | Decimal.decimal(),
           saturation :: float | Decimal.decimal(),
           value :: float | Decimal.decimal()}
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

  @doc """
  Determines whether the given color is a grayscale color which basically means
  that the saturation is 0.
  """
  @doc since: "0.4.0"
  @spec grayscale?(t) :: boolean
  def grayscale?(%__MODULE__{} = color) do
    Decimal.eq?(color.saturation, 0)
  end

  @doc """
  Checks whether the hue of the given color is in the specified bounds. This
  can be used to cluster colors by their chromaticity.
  """
  @doc since: "0.4.0"
  @spec hue_between?(
          t,
          min :: float | Decimal.decimal(),
          max :: float | Decimal.decimal()
        ) :: boolean
  def hue_between?(%__MODULE__{} = color, min, max) do
    Decimal.cmp(color.hue, Decimal.cast(min)) in [:gt, :eq] &&
      Decimal.lt?(color.hue, Decimal.cast(max))
  end

  @cluster_table [
    {0, 35, :red},
    {35, 64, :yellow},
    {64, 181, :green},
    {181, 272, :blue},
    {272, 345, :magenta},
    {345, 360, :red}
  ]

  def cluster(color) do
    cond do
      Decimal.lt?(color.saturation, "0.15") ->
        :grayish

      Decimal.lt?(color.value, "0.2") ->
        :grayish

      true ->
        Enum.find_value(@cluster_table, fn {min_hue, max_hue, category} ->
          if hue_between?(color, min_hue, max_hue), do: category
        end)
    end
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
