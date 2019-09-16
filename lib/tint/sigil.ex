defmodule Tint.Sigil do
  @moduledoc """
  A module providing a sigil to build colors in a certain colorspace.
  """

  alias Tint.HSV
  alias Tint.RGB

  @separator ","

  @doc """
  A sigil to build a color.
  """
  @spec sigil_K(String.t(), [char]) :: Tint.color()
  def sigil_K(str, []) do
    RGB.from_hex!(str)
  end

  def sigil_K(str, [?r]) do
    apply(RGB, :new, extract_args(str, 3))
  end

  def sigil_K(str, [?h]) do
    apply(HSV, :new, extract_args(str, 3))
  end

  defp extract_args(str, expected_count) do
    args =
      str
      |> String.split(@separator)
      |> Enum.map(&String.trim/1)

    args_count = length(args)

    if args_count != expected_count do
      raise ArgumentError,
            "Invalid number of args: #{args_count} " <>
              "(expected #{expected_count})"
    end

    args
  end
end
