# Tint

[![Build Status](https://travis-ci.org/tlux/tint.svg?branch=master)](https://travis-ci.org/tlux/tint)
[![Coverage Status](https://coveralls.io/repos/github/tlux/tint/badge.svg?branch=master)](https://coveralls.io/github/tlux/tint?branch=master)
[![Hex.pm](https://img.shields.io/hexpm/v/tint.svg)](https://hex.pm/packages/tint)

An Elixir library allowing calculations with colors and conversions between
different colorspaces.

Currently supports the [RGB](https://en.wikipedia.org/wiki/RGB_color_space),
[CMYK](https://en.wikipedia.org/wiki/CMYK_color_model) and [HSV](https://en.wikipedia.org/wiki/HSL_and_HSV) color models.

## Prerequisites

-   Elixir 1.7 or greater

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `tint` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:tint, "~> 0.3"}
  ]
end
```

## Usage

### RGB

```elixir
iex> Tint.RGB.new(255, 0, 0)
#Tint.RGB<255,0,0>
```

### CMYK

```elixir
iex> Tint.CMYK.new(0.55, 0.26, 0.24, 0.65)
#Tint.CMYK<55%,26%,24%,65%>
```

### HSV

```elixir
iex> Tint.HSV.new(25.8, 0.882, 1)
#Tint.HSV<25.8°,88.2%,100%>
```

### Conversion

#### Between Colorspaces

```elixir
iex> rgb = Tint.RGB.new(255, 0, 0)
...> Tint.to_hsv(rgb)
#Tint.HSV<0°,100%,100%>
```

#### Hex Code

```elixir
iex> Tint.RGB.from_hex("#FF0000")
{:ok, #Tint.RGB<255,0,0>}
```

```elixir
iex> Tint.RGB.from_hex("invalid hex code")
:error
```

## Docs

Documentation can be generated with
[ExDoc](https://github.com/elixir-lang/ex_doc) and published on
[HexDocs](https://hexdocs.pm). The docs can be found at
<https://hexdocs.pm/tint>.
