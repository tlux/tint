defprotocol Tint.Convertible do
  @moduledoc """
  A protocol that can be implemented by color types to convert colors to
  particular colorspaces.
  """

  @spec convert(Tint.color(), Tint.colorspace()) :: {:ok, Tint.color()} | :error
  def convert(from, to)
end
