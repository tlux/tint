defmodule Tint.RGB do
  @moduledoc """
  A color in the RGB (red, green, blue) colorspace.
  """

  import Tint.Utils

  alias Tint.RGB.Convertible
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
  Builds a new RGB color from red, green and blue color values. Please always
  use this function to build a new RGB struct from red, green and blue color
  components.

  ## Examples

      iex> Tint.RGB.new(0, 0, 0)
      #Tint.RGB<0,0,0>

      iex> Tint.RGB.new(255, 127, 30)
      #Tint.RGB<255,127,30>

      iex> Tint.RGB.new(256, -1, 0)
      ** (Tint.OutOfRangeError) Value 256 is out of range [0,255]
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
  Calculates the distance of two colors using the
  [Euclidean distance](https://en.wikipedia.org/wiki/Euclidean_distance)
  algorithm.

  ## Options

  * `:weights` - A tuple defining the weights for the red, green and blue color
    components. Defaults to `{1, 1, 1}`.
  """
  @doc since: "0.2.0"
  @spec euclidean_distance(t, Convertible.t()) :: float
  def euclidean_distance(%__MODULE__{} = color, other_color, opts \\ []) do
    other_color = Convertible.to_rgb(other_color)

    {red_weight, green_weight, blue_weight} =
      Keyword.get(opts, :weights, {1, 1, 1})

    :math.sqrt(
      red_weight * :math.pow(color.red - other_color.red, 2) +
        green_weight * :math.pow(color.green - other_color.green, 2) +
        blue_weight * :math.pow(color.blue - other_color.blue, 2)
    )
  end

  @doc """
  Builds a new RGB color from the given hex code.

  ## Examples

      iex> Tint.RGB.from_hex("#FF7F1E")
      {:ok, %Tint.RGB{red: 255, green: 127, blue: 30}}

      iex> Tint.RGB.from_hex("invalid")
      :error
  """
  @spec from_hex(String.t()) :: {:ok, t} | :error
  def from_hex(code) do
    HexCode.parse(code)
  end

  @doc """
  Builds a new RGB color from the given hex code. Raises when the given hex code
  is invalid.

  ## Examples

      iex> Tint.RGB.from_hex!("#FF7F1E")
      #Tint.RGB<255,127,30>

      iex> Tint.RGB.from_hex!("invalid")
      ** (ArgumentError) Invalid hex code: invalid
  """
  @spec from_hex!(String.t()) :: t | no_return
  def from_hex!(code) do
    case from_hex(code) do
      {:ok, color} -> color
      :error -> raise ArgumentError, "Invalid hex code: #{code}"
    end
  end

  @doc """
  Builds a new RGB color from red, green and blue color ratios.

  ## Example

      iex> Tint.RGB.from_ratios(1, 0.5, 0)
      #Tint.RGB<255,128,0>
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
  Converts a tuple containing hue, saturation and value into a `Tint.RGB`
  struct.

  ## Example

      iex> Tint.RGB.from_tuple({255, 127, 30})
      #Tint.RGB<255,127,30>
  """
  @spec from_tuple(
          {Decimal.t() | number, Decimal.t() | number, Decimal.t() | number}
        ) :: t
  def from_tuple({red, green, blue}) do
    new(red, green, blue)
  end

  @doc """
  A version of the Euclidean distance algorithm that uses weights that are
  optimized for human color perception.
  """
  @doc since: "0.2.0"
  @spec human_euclidean_distance(t, Convertible.t()) :: float
  def human_euclidean_distance(%__MODULE__{} = color, other_color) do
    weights =
      if color.red < 128 do
        {2, 4, 3}
      else
        {3, 4, 2}
      end

    euclidean_distance(color, other_color, weights: weights)
  end

  @doc """
  Finds the nearest color for the specified color using the given color palette
  and an optional distance algorithm.
  """
  @doc since: "0.2.0"
  @spec nearest(t(), [Convertible.t()], (t, t -> number)) ::
          nil | Convertible.t()
  def nearest(
        %__MODULE__{} = color,
        palette,
        distance_algorithm \\ &human_euclidean_distance/2
      ) do
    Enum.min_by(
      palette,
      fn other_color ->
        distance_algorithm.(color, Convertible.to_rgb(other_color))
      end,
      fn -> nil end
    )
  end

  @doc """
  Converts a RGB color to a hex code.

  ## Example

      iex> Tint.RGB.to_hex(%Tint.RGB{red: 255, green: 127, blue: 30})
      "#FF7F1E"
  """
  @spec to_hex(t) :: String.t()
  def to_hex(%__MODULE__{} = color) do
    HexCode.serialize(color)
  end

  @doc """
  Converts RGB color into a tuple containing the red, green and blue parts.

  ## Example

      iex> Tint.RGB.to_tuple(%Tint.RGB{red: 255, green: 127, blue: 30})
      {255, 127, 30}
  """
  @spec to_tuple(t) :: {non_neg_integer, non_neg_integer, non_neg_integer}
  def to_tuple(%__MODULE__{} = color) do
    {color.red, color.green, color.blue}
  end

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(color, opts) do
      concat([
        "#Tint.RGB<",
        to_doc(color.red, opts),
        ",",
        to_doc(color.green, opts),
        ",",
        to_doc(color.blue, opts),
        ">"
      ])
    end
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
