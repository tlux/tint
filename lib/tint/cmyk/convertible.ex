defprotocol Tint.CMYK.Convertible do
  @moduledoc """
  A protocol that can be implemented by color structs to support CMYK colorspace
  conversion.
  """
  @moduledoc since: "0.3.0"

  @doc """
  Converts the specified color to the CMYK colorspace.
  """
  @spec to_cmyk(Tint.color()) :: Tint.CMYK.t()
  def to_cmyk(color)
end
