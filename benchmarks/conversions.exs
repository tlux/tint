alias Tint.RGB

color = RGB.new(255, 204, 153)

Benchee.run(%{
  "Hex Code to RGB" => fn ->
    RGB.from_hex!("#FFCC99")
  end,
  "RGB to Hex Code" => fn ->
    RGB.to_hex(color)
  end,
  "RGB to CMYK" => fn ->
    Tint.to_cmyk(color)
  end,
  "RGB to DIN99" => fn ->
    Tint.to_din99(color)
  end,
  "RGB to HSV" => fn ->
    Tint.to_hsv(color)
  end,
  "RGB to Lab" => fn ->
    Tint.to_lab(color)
  end,
  "RGB to XYZ" => fn ->
    Tint.to_xyz(color)
  end
})
