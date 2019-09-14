defmodule Tint.RGB.HexCode do
  @moduledoc false

  alias Tint.RGB

  @prefix "#"

  @spec parse(String.t()) :: {:ok, RGB.t()} | :error
  def parse(code)

  def parse(
        <<@prefix, red::binary-size(2), green::binary-size(2),
          blue::binary-size(2)>>
      ) do
    do_parse(red, green, blue)
  end

  def parse(
        <<@prefix, red::binary-size(1), green::binary-size(1),
          blue::binary-size(1)>>
      ) do
    red = String.duplicate(red, 2)
    green = String.duplicate(green, 2)
    blue = String.duplicate(blue, 2)
    do_parse(red, green, blue)
  end

  def parse(_), do: :error

  defp do_parse(red, green, blue) do
    with {:ok, red} <- parse_value(red),
         {:ok, green} <- parse_value(green),
         {:ok, blue} <- parse_value(blue) do
      {:ok, RGB.new(red, green, blue)}
    end
  end

  defp parse_value(str) do
    case Integer.parse(str, 16) do
      {value, ""} when value in 0..255 -> {:ok, value}
      _ -> :error
    end
  end

  @spec serialize(RGB.t()) :: String.t()
  def serialize(color) do
    red = serialize_value(color.red)
    green = serialize_value(color.green)
    blue = serialize_value(color.blue)
    Enum.join([@prefix, red, green, blue])
  end

  defp serialize_value(value) do
    value
    |> Integer.to_string(16)
    |> String.pad_leading(2, "0")
  end
end
