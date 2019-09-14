defmodule Tint.HSV do
  defstruct [:hue, :saturation, :value]

  @type t :: %__MODULE__{
          hue: number,
          saturation: float,
          value: float
        }

  defguardp is_hue(value) when is_number(value) and value >= 0 and value <= 360

  defguardp is_percentage(value)
            when is_float(value) and value >= 0 and value <= 1

  @doc """
  Builds a new HSV color from a tuple.
  """
  @spec new({number, number, number}) :: t
  def new({hue, saturation, value}) do
    new(hue, saturation, value)
  end

  @doc """
  Builds a new HSV color from hue, saturation and value color parts.
  """
  @spec new(number, number, number) :: t
  def new(hue, saturation, value)
      when is_hue(hue) and
             is_percentage(saturation) and
             is_percentage(value) do
    %__MODULE__{hue: hue, saturation: saturation / 1, value: value / 1}
  end

  defimpl Tint.HSV.Convertible do
    def to_hsv(hsv), do: hsv
  end

  defimpl Tint.RGB.Convertible do
    def to_rgb(rgb) do
    end
  end
end
