defmodule Tint.RGB.HexCode do
  @moduledoc false

  alias Tint.RGB

  @spec parse(String.t()) :: {:ok, RGB.t()} | {:error, Tint.error()}
  def parse(code) do
    # TODO
    {:ok, RGB.new(0, 0, 0)}
  end

  @spec serialize(RGB.t()) :: String.t()
  def serialize(color) do
    # TODO
    "#000000"
  end
end
