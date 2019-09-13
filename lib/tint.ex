defmodule Tint do
  @moduledoc """
  a library to convert colors between different colorspaces.
  """

  alias Tint.Convertible
  alias Tint.UnconvertibleError

  @typedoc """
  A type representing a color.
  """
  @type color :: Convertible.t()

  @typedoc """
  A type referencing a colorspace module.
  """
  @type colorspace :: Tint.HSV | Tint.RGB

  @typedoc """
  A union type containing all possible error types that this library has.
  """
  @type error :: UnconvertibleError.t()

  @doc """
  Converts a color to another colorspace.
  """
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

  @doc """
  Converts a color to another colorspace. Raises when the conversion fails.
  """
  @spec convert!(Tint.color(), Tint.colorspace()) :: Tint.color() | no_return
  def convert!(from, to) do
    case convert(from, to) do
      {:ok, color} -> color
      {:error, error} -> raise error
    end
  end
end
