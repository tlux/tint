defimpl Tint.CMYK.Convertible, for: Tint.RGB do
  alias Tint.CMYK
  alias Tint.RGB

  def to_cmyk(%{red: 0, green: 0, blue: 0}) do
    %CMYK{cyan: 0.0, magenta: 0.0, yellow: 0.0, key: 1.0}
  end

  def to_cmyk(color) do
    {red_ratio, green_ratio, blue_ratio} = RGB.to_ratios(color)
    max_ratio = Enum.max([red_ratio, green_ratio, blue_ratio])

    raw_key = 1 - max_ratio
    cyan = calc_value(raw_key, red_ratio)
    magenta = calc_value(raw_key, green_ratio)
    yellow = calc_value(raw_key, blue_ratio)
    key = round_channel(raw_key)

    %CMYK{cyan: cyan, magenta: magenta, yellow: yellow, key: key}
  end

  defp calc_value(key, ratio) do
    round_channel((1.0 - ratio - key) / (1.0 - key))
  end

  defp round_channel(channel) do
    Float.round(channel, 4)
  end
end
