defimpl Tint.RGB.Convertible, for: Tint.CMYK do
  alias Tint.RGB

  def convert(color) do
    red = calc_channel(color.key, color.cyan)
    green = calc_channel(color.key, color.magenta)
    blue = calc_channel(color.key, color.yellow)
    %RGB{red: red, green: green, blue: blue}
  end

  defp calc_channel(key, cmyk_channel) do
    round(255 * (1 - cmyk_channel) * (1 - key))
  end
end
