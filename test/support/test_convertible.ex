defmodule Tint.TestConvertible do
  defstruct [:value]

  defimpl Tint.Convertible do
    alias Tint.RGB

    def convert(_color, RGB) do
      {:ok, RGB.new(1, 2, 3)}
    end

    def convert(_, _) do
      :error
    end
  end
end
