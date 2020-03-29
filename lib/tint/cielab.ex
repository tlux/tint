defmodule Tint.CIELAB do
  @moduledoc """
  A color in the CIELAB colorspace.
  """
  @moduledoc since: "0.4.0"

  defstruct [:lightness, :a, :b]

  alias Tint.CIELAB.Convertible
  alias Tint.Distance

  @type t :: %__MODULE__{
          lightness: Decimal.t(),
          a: Decimal.t(),
          b: Decimal.t()
        }

  @spec new(
          float | Decimal.decimal(),
          float | Decimal.decimal(),
          float | Decimal.decimal()
        ) :: t
  def new(lightness, a, b) do
    %__MODULE__{
      lightness: cast_value(lightness),
      a: cast_value(a),
      b: cast_value(b)
    }
  end

  defp cast_value(value) do
    value
    |> Decimal.cast()
    |> Decimal.round(4)
  end

  @spec from_tuple(
          {lightness :: float | Decimal.decimal(),
           a :: float | Decimal.decimal(), b :: float | Decimal.decimal()}
        ) :: t
  def from_tuple({lightness, a, b}) do
    new(lightness, a, b)
  end

  @spec to_tuple(t) :: {Decimal.t(), Decimal.t(), Decimal.t()}
  def to_tuple(%__MODULE__{} = color) do
    {color.lightness, color.a, color.b}
  end

  @spec ciede2000_distance(t, Convertible.t()) :: float
  def ciede2000_distance(%__MODULE__{} = color, other_color, opts \\ []) do
    Distance.CIEDE2000.ciede2000_distance(
      color,
      Convertible.to_lab(other_color),
      opts
    )
  end

  @spec nearest(t, [Convertible.t()], (t, t -> number)) ::
          nil | Convertible.t()
  def nearest(
        %__MODULE__{} = color,
        palette,
        distance_algorithm \\ &ciede2000_distance/2
      ) do
    Distance.nearest(color, palette, &Convertible.to_lab/1, distance_algorithm)
  end
end
