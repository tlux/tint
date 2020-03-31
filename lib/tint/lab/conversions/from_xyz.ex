defimpl Tint.Lab.Convertible, for: Tint.XYZ do
  alias Tint.Lab
  alias Tint.Utils.Math

  @ratio_1 216 / 24_389.0
  @ratio_2 24_389 / 27.0
  @xn 95.0489
  @yn 100.0
  @zn 108.8840

  def to_lab(color) do
    yr = inner_fun(color.y / @yn)
    lightness = round_channel(116 * yr - 16)
    a = round_channel(500 * (inner_fun(color.x / @xn) - yr))
    b = round_channel(200 * (yr - inner_fun(color.z / @zn)))
    %Lab{lightness: lightness, a: a, b: b}
  end

  defp inner_fun(value) do
    if value < @ratio_1 do
      1 / 116.0 * (@ratio_2 * value + 16)
    else
      Math.nth_root(value, 3)
    end
  end

  defp round_channel(channel) do
    Float.round(channel, 4)
  end
end
