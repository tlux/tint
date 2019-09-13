defprotocol Tint.Convertible do
  @spec convert(Tint.color(), Tint.colorspace()) ::
          {:ok, Tint.color()} | {:error, Tint.error()}
  def convert(from, to)
end
