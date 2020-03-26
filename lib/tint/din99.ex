defmodule Tint.DIN99 do
  @moduledoc """
  A color in the DIN99 colorspace.
  """
  @moduledoc since: "0.4.0"

  defstruct [:l, :a, :b]

  alias Tint.DIN99.Convertible
  alias Tint.Utils

  @type t :: %__MODULE__{
          l: Decimal.t(),
          a: Decimal.t(),
          b: Decimal.t()
        }

  @spec new(
          float | Decimal.decimal(),
          float | Decimal.decimal(),
          float | Decimal.decimal()
        ) :: t
  def new(l, a, b) do
    %__MODULE__{l: cast_value(l), a: cast_value(a), b: cast_value(b)}
  end

  defp cast_value(value) do
    value
    |> Decimal.cast()
    |> Decimal.round(3)
  end

  @spec delta_e(t, Convertible.t()) :: float
  def delta_e(%__MODULE__{} = color, other_color) do
    Utils.delta_e(color, Convertible.to_din99(other_color))
  end

  @spec nearest(t, [Convertible.t()], (t, t -> number)) ::
          nil | Convertible.t()
  def nearest(
        %__MODULE__{} = color,
        palette,
        distance_algorithm \\ &delta_e/2
      ) do
    Utils.nearest(color, palette, distance_algorithm, &Convertible.to_din99/1)
  end
end
