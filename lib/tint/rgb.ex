defmodule Tint.RGB do
  alias Tint.RGB.HexCode

  defstruct [:red, :green, :blue]

  @type value :: 0..255

  @type t :: %__MODULE__{
          red: value,
          green: value,
          blue: value
        }

  defguardp is_rgb_value(value) when is_integer(value) and value in 0..255

  @doc """
  Builds a new RGB color from a tuple.
  """
  @spec new({value, value, value}) :: t
  def new({red, green, blue}) do
    new(red, green, blue)
  end

  @doc """
  Builds a new RGB color from red, green and green color values.
  """
  @spec new(value, value, value) :: t
  def new(red, green, blue)
      when is_rgb_value(red) and is_rgb_value(green) and is_rgb_value(blue) do
    %__MODULE__{red: red, green: green, blue: blue}
  end

  @doc """
  Builds a new RGB color from the given hex code.
  """
  @spec from_hex(String.t()) :: {:ok, t} | :error
  def from_hex(code) do
    HexCode.parse(code)
  end

  @doc """
  Builds a new RGB color from the given hex code. Raises when the given hex code
  is invalid.
  """
  @spec from_hex!(String.t()) :: t | no_return
  def from_hex!(code) do
    case from_hex(code) do
      {:ok, color} -> color
      :error -> raise ArgumentError, "Invalid hex code: #{code}"
    end
  end

  @doc """
  Converts a RGB color to a hex code.
  """
  @spec to_hex(t) :: String.t()
  def to_hex(%__MODULE__{} = color) do
    HexCode.serialize(color)
  end

  defimpl Tint.Convertible do
    def convert(rgb, Tint.HSV) do
      {:ok, nil}
    end

    def convert(_from, _to), do: :error
  end
end
