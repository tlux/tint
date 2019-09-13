defmodule Tint.HSV do
  defstruct [:hue, :saturation, :value]

  @type t :: %__MODULE__{
          hue: non_neg_integer,
          saturation: non_neg_integer,
          value: non_neg_integer
        }

  @spec new(non_neg_integer, non_neg_integer, non_neg_integer) :: t
  def new(hue, saturation, value) do
    %__MODULE__{hue: hue, saturation: saturation, value: value}
  end
end
