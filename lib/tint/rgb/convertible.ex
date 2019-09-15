defprotocol Tint.RGB.Convertible do
  @moduledoc """
  A protocol that can be implemented by color structs to support RGB colorspace
  conversion.
  """

  @doc """
  Converts the specified color to the RGB colorspace.
  """
  @spec to_rgb(Tint.color()) :: Tint.RGB.t()
  def to_rgb(color)
end
