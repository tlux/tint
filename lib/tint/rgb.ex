defmodule Tint.RGB do
  alias Tint.RGB.HexCode

  defstruct [:red, :green, :blue]

  @type t :: %__MODULE__{
          red: non_neg_integer,
          green: non_neg_integer,
          blue: non_neg_integer
        }

  @doc """
  Builds a new RGB color.
  """
  @spec new(non_neg_integer, non_neg_integer, non_neg_integer) :: t
  def new(red, green, blue) do
    %__MODULE__{red: red, green: green, blue: blue}
  end

  @doc """
  Builds a new RGB color from the given hex code.
  """
  @spec from_hex(String.t()) :: {:ok, t} | {:error, Tint.error()}
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
      {:error, error} -> raise error
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
