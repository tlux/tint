# Tint

[![Build Status](https://travis-ci.org/tlux/tint.svg?branch=master)](https://travis-ci.org/tlux/tint)
[![Coverage Status](https://coveralls.io/repos/github/tlux/tint/badge.svg?branch=master)](https://coveralls.io/github/tlux/tint?branch=master)
[![Hex.pm](https://img.shields.io/hexpm/v/tint.svg)](https://hex.pm/packages/tint)

An Elixir library allowing calculations with colors and conversions between
different colorspaces.

Currently supports the following color models:
* [RGB](https://en.wikipedia.org/wiki/RGB_color_space)
* [CMYK](https://en.wikipedia.org/wiki/CMYK_color_model)
* [HSV](https://en.wikipedia.org/wiki/HSL_and_HSV)
* XYZ ([CIE 1931](https://en.wikipedia.org/wiki/CIE_1931_color_space))
* Lab ([CIELAB](https://en.wikipedia.org/wiki/CIELAB_color_space))
* [DIN99](https://de.wikipedia.org/wiki/DIN99-Farbraum)

## Prerequisites

* Elixir 1.7 or greater

## Installation

The package can be installed by adding `tint` to your list of dependencies in
`mix.exs`:

```elixir
def deps do
  [
    {:tint, "~> 0.4"}
  ]
end
```

## Usage

### Colorspaces

#### RGB

```elixir
iex> Tint.RGB.new(255, 0, 0)
#Tint.RGB<255,0,0>
```

or

```elixir
iex> import Tint.Sigil
...> ~K[255, 0, 0]r
#Tint.RGB<255,0,0>
```

#### CMYK

```elixir
iex> Tint.CMYK.new(0.55, 0.26, 0.24, 0.65)
#Tint.CMYK<55%,26%,24%,65%>
```

or

```elixir
iex> import Tint.Sigil
...> ~K[0.55, 0.26, 0.24, 0.65]c
#Tint.CMYK<55%,26%,24%,65%>
```

#### HSV

```elixir
iex> Tint.HSV.new(25.8, 0.882, 1)
#Tint.HSV<25.8°,88.2%,100%>
```

or

```elixir
iex> import Tint.Sigil
...> ~K[25.8, 0.882, 1]h
#Tint.HSV<25.8°,88.2%,100%>
```

#### CIELAB

```elixir
iex> Tint.Lab.new(53.2329, 80.1068, 67.2202)
#Tint.Lab<53.2329,80.1068,67.2202>
```

or

```elixir
iex> import Tint.Sigil
...> ~K[53.2329, 80.1068, 67.2202]c
#Tint.Lab<53.2329,80.1068,67.2202>
```

#### DIN99

```elixir
iex> Tint.DIN99.new(53.2329, 80.1068, 67.2202)
#Tint.DIN99<53.2329,80.1068,67.2202>
```

or

```elixir
iex> import Tint.Sigil
...> ~K[53.2329, 80.1068, 67.2202]d
#Tint.DIN99<53.2329,80.1068,67.2202>
```

### Conversion

#### Between Colorspaces

```elixir
iex> rgb = Tint.RGB.new(255, 0, 0)
...> Tint.to_hsv(rgb)
#Tint.HSV<0°,100%,100%>
```

The complete list:

```elixir
Tint.to_cmyk(color)
Tint.to_din99(color)
Tint.to_hsv(color)
Tint.to_lab(color)
Tint.to_rgb(color)
Tint.to_xyz(color)
```

Currently, only RGB can be converted to any other colorspace.

#### Hex Code

```elixir
iex> Tint.RGB.from_hex("#FF0000")
{:ok, #Tint.RGB<255,0,0>}
```

```elixir
iex> Tint.RGB.from_hex("invalid hex code")
:error
```

```elixir
iex> Tint.RGB.to_hex(Tint.RGB.new(255, 0, 0))
"#FF0000"
```

Alternatively, you can use the sigil as a shortcut:

```elixir
iex> import Tint.Sigil
...> ~K[#FF0000]
#Tint.RGB<255,0,0>
```

### Color Distance

There are functions to calculate the distance between two colors.

#### Euclidean Distance (Delta E)

The Delta E algorithm operates on the RGB colorspace. Given colors are converted
before calculation if needed. Delta E is very fast but may not be very precise.
If you want maximum precision use the CIEDE2000 algorithm.

```elixir
iex> Tint.Distance.Euclidean.euclidean_distance(~K[#FFFFFF], ~K[#000000])
441.6729559300637
```

There is an alternative implementation using weights that are optimized for
human color perception:

```elixir
iex> Tint.Distance.Euclidean.human_euclidean_distance(~K[#FFFFFF], ~K[#000000])
765.0
```

To find the nearest color from a given palette:

```elixir
iex> Tint.RGB.nearest_color(~K[#CC0000], [~K[#009900], ~K[#FF0000]])
#Tint.RGB<255,0,0>
```

#### CIEDE2000

[CIEDE2000](https://en.wikipedia.org/wiki/Color_difference#CIEDE2000) is an
algorithm that operates on the CIELAB colorspace. Given colors are converted
before calculation if needed. It is very slow compared to Delta E but it is
optimized to human color perception.

```elixir
iex> Tint.Distance.CIEDE2000.ciede2000_distance(~K[#FF0000], ~K[#000000])
50.3905024704449
```

To find the nearest color from a given palette:

```elixir
iex> color = Tint.to_lab(~K[#CC0000])
...> Tint.Lab.nearest_color(color, [~K[#009900], ~K[#FF0000]])
#Tint.RGB<255,0,0>
```

## Docs

The API docs can be found at [HexDocs](https://hexdocs.pm/tint).
