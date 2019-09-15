defprotocol Tint.HSV.Convertible do
  @moduledoc """
  A protocol that can be implemented by color structs to support HSV colorspace
  conversion.
  """

  @doc """
  Converts the specified color to the HSV colorspace.
  """
  @spec to_hsv(Tint.color()) :: Tint.HSV.t()
  def to_hsv(color)
end
