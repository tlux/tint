defmodule Tint do
  alias Tint.Convertible
  alias Tint.UnconvertibleError

  @type color :: Convertible.t()
  @type colorspace :: module
  @type error :: any

  @spec convert(Tint.color(), Tint.colorspace()) ::
          {:ok, Tint.color()} | {:error, Tint.error()}
  def convert(from, to)

  def convert(%colorspace{} = color, colorspace) do
    {:ok, color}
  end

  def convert(from, to) do
    case Convertible.convert(from, to) do
      {:ok, color} -> {:ok, color}
      :error -> {:error, %UnconvertibleError{from: from, to: to}}
    end
  end

  @spec convert!(Tint.color(), Tint.colorspace()) :: Tint.color() | no_return
  def convert!(from, to) do
    case convert(from, to) do
      {:ok, color} -> color
      {:error, error} -> raise error
    end
  end
end
