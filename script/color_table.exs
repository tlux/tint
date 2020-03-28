alias Tint.{CIELAB, RGB}

known_colors =
  Enum.map(
    [
      "#000000",
      "#008B93",
      "#00A1DE",
      "#07403F",
      "#171E31",
      "#1FE7FF",
      "#222D49",
      "#226EB6",
      "#293133",
      "#2C3539",
      "#2E3034",
      "#3096C3",
      "#313433",
      "#313851",
      "#3355E7",
      "#389EFD",
      "#398AC5",
      "#3D4053",
      "#3F4044",
      "#3F678C",
      "#416E71",
      "#424242",
      "#424359",
      "#425A7B",
      "#434245",
      "#434343",
      "#43455C",
      "#43475A",
      "#4765B2",
      "#484B50",
      "#4A526A",
      "#52514F",
      "#56B6CB",
      "#575A61",
      "#5B6770",
      "#5DF6FF",
      "#5E6FAB",
      "#5F6F63",
      "#64A7AC",
      "#6C6C6C",
      "#6D7A71",
      "#707070",
      "#73A0B9",
      "#797DB9",
      "#799DC9",
      "#7A7A7A",
      "#807F84",
      "#87B1FD",
      "#89D63D",
      "#8C8D92",
      "#8D36B3",
      "#955231",
      "#9ABD25",
      "#9B5532",
      "#9F5B37",
      "#A65D5D",
      "#A96B45",
      "#AF6E48",
      "#B2052C",
      "#B2B2B2",
      "#B2E0CD",
      "#B357B3",
      "#B41325",
      "#B5C09F",
      "#B6B6B6",
      "#B76A40",
      "#BDBDBD",
      "#C1333A",
      "#C1C4C9",
      "#C39691",
      "#C8373B",
      "#CACBCC",
      "#CBCBCB",
      "#D0A8A0",
      "#D0D0D0",
      "#D0D0D4",
      "#D1CDDC",
      "#D3BDBB",
      "#D4BBA3",
      "#D6FFD6",
      "#D71F1F",
      "#D7BFBE",
      "#DACCB3",
      "#DBDBDB",
      "#E045AD",
      "#E0B29C",
      "#E0E1E1",
      "#E2E2E2",
      "#E2E3E4",
      "#E5412C",
      "#E54E44",
      "#E6E6E6",
      "#E7CDB0",
      "#E7E7E7",
      "#EBEBE3",
      "#F2D9CE",
      "#F3F3F3",
      "#F4896F",
      "#F7DCC1",
      "#F9D045",
      "#FBD7BD",
      "#FCE67A",
      "#FECB00",
      "#FEFDFE",
      "#FF0066",
      "#FF9A1E",
      "#FFC0CB",
      "#FFFFFF"
    ],
    &RGB.from_hex!/1
  )

palette =
  Enum.map(
    [
      "#000000",
      "#6C6C6C",
      "#D0D0D0",
      "#FFFFFF",
      "#D71F1F",
      "#FF9A1E",
      "#FECB00",
      "#FF0066",
      "#FFC0CB",
      "#E7CDB0",
      "#B76A40",
      "#89D63D",
      "#D6FFD6",
      "#00A1DE",
      "#5DF6FF",
      "#B357B3"
    ],
    &RGB.from_hex!/1
  )

file = File.open!("color_table.html", [:write, :binary])

add_color_row = fn color ->
  hex_code = RGB.to_hex(color)
  lab_color = Tint.to_lab(color)

  quant_hex_codes_with_distance =
    palette
    |> Enum.map(fn palette_color ->
      {RGB.to_hex(palette_color),
       CIELAB.delta_e_ciede2000(lab_color, Tint.to_lab(palette_color))}
    end)
    |> Enum.sort_by(&elem(&1, 1))
    |> Enum.take(3)

  IO.write(file, """
    <tr>
      <td style="background-color: #{hex_code}">#{hex_code}</td>
  """)

  for {quant_hex_code, distance} <- quant_hex_codes_with_distance do
    IO.write(file, """
      <td style="background-color: #{quant_hex_code}">
        #{quant_hex_code}
        <small>(#{round(distance)})</small>
      </td>
    """)
  end

  IO.write(file, """
    </tr>
  """)
end

IO.write(file, """
<h1>Palette</h1>
<table>
  <tbody>
""")

for color <- palette,
    hex_code = RGB.to_hex(color) do
  IO.write(file, """
    <tr>
      <td style="background-color: #{hex_code}">#{hex_code}</td>
    </tr>
  """)
end

IO.write(file, """
  </tbody>
</table>

<h1>Known Colors</h1>
<table>
  <thead>
    <tr>
      <th>Orig</th>
      <th>CIEDE2000</th>
    </tr>
  </thead>
  <tbody>
""")

for color <- known_colors do
  add_color_row.(color)
end

IO.write(file, """
  </tbody>
</table>
""")

File.close(file)
