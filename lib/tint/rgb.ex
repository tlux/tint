defmodule Tint.RGB do
  @moduledoc """
  A color in the RGB (red, green, blue) colorspace.
  """

  import Tint.Utils

  alias Tint.RGB.HexCode
  alias Tint.Utils.Interval

  defstruct [:red, :green, :blue]

  @value_interval Interval.new(0, 255)
  @ratio_interval Interval.new(0, 1)

  @type t :: %__MODULE__{
          red: non_neg_integer,
          green: non_neg_integer,
          blue: non_neg_integer
        }

  @doc """
  Builds a new RGB color from red, green and blue color values.
  """
  @spec new(Decimal.t() | number, Decimal.t() | number, Decimal.t() | number) ::
          t
  def new(red, green, blue) do
    with {:ok, red} <- check_and_cast_value(:integer, red, @value_interval),
         {:ok, green} <- check_and_cast_value(:integer, green, @value_interval),
         {:ok, blue} <- check_and_cast_value(:integer, blue, @value_interval) do
      %__MODULE__{red: red, green: green, blue: blue}
    else
      {:error, error} -> raise error
    end
  end

  @doc """
  Converts a tuple containing hue, saturation and value into a `Tint.RGB`
  struct.
  """
  @spec from_tuple(
          {Decimal.t() | number, Decimal.t() | number, Decimal.t() | number}
        ) :: t
  def from_tuple({red, green, blue}) do
    new(red, green, blue)
  end

  @doc """
  Converts RGB color into a tuple containing the red, green and blue parts.
  """
  @spec to_tuple(t) :: {non_neg_integer, non_neg_integer, non_neg_integer}
  def to_tuple(%__MODULE__{} = color) do
    {color.red, color.green, color.blue}
  end

  @doc """
  Builds a new RGB color from red, green and blue color ratios.
  """
  @spec from_ratios(
          Decimal.t() | number,
          Decimal.t() | number,
          Decimal.t() | number
        ) :: t
  def from_ratios(red_ratio, green_ratio, blue_ratio) do
    with {:ok, red_ratio} <-
           check_and_cast_value(:decimal, red_ratio, @ratio_interval),
         {:ok, green_ratio} <-
           check_and_cast_value(:decimal, green_ratio, @ratio_interval),
         {:ok, blue_ratio} <-
           check_and_cast_value(:decimal, blue_ratio, @ratio_interval) do
      %__MODULE__{
        red: ratio_to_value(red_ratio),
        green: ratio_to_value(green_ratio),
        blue: ratio_to_value(blue_ratio)
      }
    else
      {:error, error} -> raise error
    end
  end

  defp ratio_to_value(ratio) do
    ratio
    |> Decimal.mult(255)
    |> Decimal.round()
    |> Decimal.to_integer()
  end

  @doc """
  Builds a new RGB color from the given hex code.
  """
  @spec from_hex(String.t()) :: {:ok, t} | :error
  def from_hex(code) do
    HexCode.parse(code)
  end

  @doc """
  Builds a new RGB color from the given hex code. Raises when the given hex code
  is invalid.
  """
  @spec from_hex!(String.t()) :: t | no_return
  def from_hex!(code) do
    case from_hex(code) do
      {:ok, color} -> color
      :error -> raise ArgumentError, "Invalid hex code: #{code}"
    end
  end

  @doc """
  Converts a RGB color to a hex code.
  """
  @spec to_hex(t) :: String.t()
  def to_hex(%__MODULE__{} = color) do
    HexCode.serialize(color)
  end

  defimpl Tint.RGB.Convertible do
    def to_rgb(rgb), do: rgb
  end

  defimpl Tint.HSV.Convertible do
    alias Tint.HSV

    def to_hsv(rgb) do
      red_ratio = calc_ratio(rgb.red)
      green_ratio = calc_ratio(rgb.green)
      blue_ratio = calc_ratio(rgb.blue)
      rgb_ratios = [red_ratio, green_ratio, blue_ratio]

      min_ratio = Enum.reduce(rgb_ratios, &Decimal.min(&1, &2))
      max_ratio = Enum.reduce(rgb_ratios, &Decimal.max(&1, &2))
      ratio_delta = Decimal.sub(max_ratio, min_ratio)

      hue = calc_hue(ratio_delta, max_ratio, rgb_ratios)
      saturation = calc_saturation(ratio_delta, max_ratio)

      HSV.new(hue, saturation, max_ratio)
    end

    defp calc_ratio(value) do
      Decimal.div(value, 255)
    end

    defp calc_hue(ratio_delta, max_ratio, rgb_ratios) do
      hue = do_calc_hue(ratio_delta, max_ratio, rgb_ratios)

      if Decimal.lt?(hue, 0) do
        Decimal.add(hue, 360)
      else
        hue
      end
    end

    defp do_calc_hue(ratio_delta, max_ratio, [
           red_ratio,
           green_ratio,
           blue_ratio
         ]) do
      cond do
        Decimal.eq?(ratio_delta, 0) ->
          Decimal.new(0)

        Decimal.eq?(red_ratio, max_ratio) ->
          calc_hue_component(green_ratio, blue_ratio, ratio_delta, 0)

        Decimal.eq?(green_ratio, max_ratio) ->
          calc_hue_component(blue_ratio, red_ratio, ratio_delta, 2)

        Decimal.eq?(blue_ratio, max_ratio) ->
          calc_hue_component(red_ratio, green_ratio, ratio_delta, 4)
      end
    end

    defp calc_hue_component(first_ratio, second_ratio, ratio_delta, offset) do
      Decimal.mult(
        60,
        Decimal.add(
          Decimal.div(Decimal.sub(first_ratio, second_ratio), ratio_delta),
          offset
        )
      )
    end

    defp calc_saturation(ratio_delta, max_ratio) do
      if Decimal.eq?(ratio_delta, 0) do
        Decimal.new(0)
      else
        Decimal.div(ratio_delta, max_ratio)
      end
    end
  end
end
