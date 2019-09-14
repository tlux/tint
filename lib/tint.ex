defmodule Tint do
  @moduledoc """
  a library to convert colors between different colorspaces.
  """

  alias Tint.HSV
  alias Tint.RGB

  @typedoc """
  A type representing a color.
  """
  @type color :: HSV.t() | RGB.t()

  @doc """
  Converts the given color to RGB colorspace.
  """
  @spec to_rgb(color) :: {:ok, RGB.t()} | :error
  def to_rgb(color) do
    RGB.Convertible.to_rgb(color)
  end

  @doc """
  Converts the given color to HSV colorspace.
  """
  @spec to_hsv(color) :: {:ok, HSV.t()} | :error
  def to_hsv(color) do
    HSV.Convertible.to_hsv(color)
  end
end
