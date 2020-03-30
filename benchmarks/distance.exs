import Tint.Sigil

alias Tint.Distance

color = ~K[#FF0000]
other_color = ~K[#00FF00]
color_in_lab = Tint.to_lab(color)
other_color_in_lab = Tint.to_lab(other_color)

Benchee.run(%{
  "RGB Delta E" => fn ->
    Distance.Euclidean.distance(color, other_color, [])
  end,
  "CIEDE2000" => fn ->
    Distance.CIEDE2000.distance(color_in_lab, other_color_in_lab, [])
  end
})
