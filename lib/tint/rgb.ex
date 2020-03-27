defmodule Tint.RGB do
  @moduledoc """
  A color in the RGB (red, green, blue) colorspace.
  """

  import Tint.Utils

  alias Tint.Distance
  alias Tint.RGB.Convertible
  alias Tint.RGB.HexCode

  defstruct [:red, :green, :blue]

  @type t :: %__MODULE__{
          red: non_neg_integer,
          green: non_neg_integer,
          blue: non_neg_integer
        }

  @doc """
  Builds a new RGB color from red, green and blue color parts. Please always
  use this function to build a new RGB color.

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
    with {:ok, red} <- cast_component(red),
         {:ok, green} <- cast_component(green),
         {:ok, blue} <- cast_component(blue) do
      %__MODULE__{red: red, green: green, blue: blue}
    else
      {:error, error} -> raise error
    end
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
    with {:ok, red_ratio} <- cast_ratio(red_ratio),
         {:ok, green_ratio} <- cast_ratio(green_ratio),
         {:ok, blue_ratio} <- cast_ratio(blue_ratio) do
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
  Builds a tuple containing the ratios of the red, green and blue components of
  a given color.
  """
  @spec to_ratios(t) :: {Decimal.t(), Decimal.t(), Decimal.t()}
  def to_ratios(%__MODULE__{} = color) do
    {calc_ratio(color.red), calc_ratio(color.green), calc_ratio(color.blue)}
  end

  defp calc_ratio(value), do: Decimal.div(value, 255)

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

  # Distance

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
    other_color = other_color |> Convertible.to_rgb() |> to_tuple()
    weights = Keyword.get(opts, :weights, {1, 1, 1})
    Distance.euclidean_distance(to_tuple(color), other_color, weights)
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
  @spec nearest(t, [Convertible.t()], (t, t -> number)) ::
          nil | Convertible.t()
  def nearest(
        %__MODULE__{} = color,
        palette,
        distance_algorithm \\ &human_euclidean_distance/2
      ) do
    Distance.nearest(color, palette, &Convertible.to_rgb/1, distance_algorithm)
  end

  @doc """
  Determines whether the given color is a grayscale color which basically means
  that the red, green and blue components of the color have the same value.
  """
  @doc since: "0.4.0"
  @spec grayscale?(t) :: boolean
  def grayscale?(color)
  def grayscale?(%__MODULE__{red: value, green: value, blue: value}), do: true
  def grayscale?(%__MODULE__{}), do: false

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(rgb, opts) do
      concat([
        "#Tint.RGB<",
        to_doc(rgb.red, opts),
        ",",
        to_doc(rgb.green, opts),
        ",",
        to_doc(rgb.blue, opts),
        ">"
      ])
    end
  end
end
