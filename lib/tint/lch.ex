defmodule Tint.LCh do
  @moduledoc since: "0.4.0"

  defstruct [:lightness, :chroma, :hue]

  @type t :: %__MODULE__{
          lightness: Decimal.t(),
          chroma: Decimal.t(),
          hue: Decimal.t()
        }

  # https://de.wikipedia.org/wiki/LCh-Farbraum
  # https://en.wikipedia.org/wiki/Color_difference#CIEDE2000
end
