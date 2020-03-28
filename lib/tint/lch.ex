defmodule Tint.LCh do
  @moduledoc since: "0.4.0"

  import Tint.Utils

  alias Tint.Distance
  alias Tint.LCh.Convertible

  defstruct [:lightness, :a, :b, :chroma, :hue]

  @type t :: %__MODULE__{
          lightness: Decimal.t(),
          a: Decimal.t(),
          b: Decimal.t(),
          chroma: Decimal.t(),
          hue: Decimal.t()
        }

  # https://de.wikipedia.org/wiki/LCh-Farbraum
  # https://en.wikipedia.org/wiki/Color_difference#CIEDE2000

  @spec new(
          float | Decimal.decimal(),
          float | Decimal.decimal(),
          float | Decimal.decimal(),
          float | Decimal.decimal(),
          float | Decimal.decimal()
        ) :: t
  def new(lightness, a, b, chroma, hue) do
    case cast_degrees(hue) do
      {:ok, hue} ->
        %__MODULE__{
          lightness: cast_value(lightness),
          a: cast_value(a),
          b: cast_value(b),
          chroma: cast_value(chroma),
          hue: hue
        }

      {:error, error} ->
        raise error
    end
  end

  defp cast_value(value) do
    value
    |> Decimal.cast()
    |> Decimal.round(3)
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
        distance_algorithm \\ &delta_e_ciede2000/2
      ) do
    Distance.nearest(color, palette, &Convertible.to_lch/1, distance_algorithm)
  end

  @spec delta_e_ciede2000(t, Convertible.t()) :: float
  def delta_e_ciede2000(%__MODULE__{} = color, other_color) do
    other_color = Convertible.to_lch(other_color)
    Distance.CIEDE2000.ciede2000(color, other_color)
  end
end
