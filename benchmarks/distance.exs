import Tint.Sigil

alias Tint.{CIELAB, RGB}

color = ~K[#FF0000]
other_color = ~K[#00FF00]
color_in_lab = Tint.to_lab(color)
other_color_in_lab = Tint.to_lab(other_color)

Benchee.run(%{
  "RGB delta_e" => fn ->
    RGB.euclidean_distance(color, other_color)
  end,
  "ciede2000" => fn ->
    CIELAB.ciede2000_distance(color_in_lab, other_color_in_lab)
  end
})
