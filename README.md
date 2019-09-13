# Tint

[![Build Status](https://travis-ci.org/tlux/file_size.svg?branch=master)](https://travis-ci.org/tlux/file_size)
[![Coverage Status](https://coveralls.io/repos/github/tlux/file_size/badge.svg?branch=master)](https://coveralls.io/github/tlux/file_size?branch=master)
[![Hex.pm](https://img.shields.io/hexpm/v/file_size.svg)](https://hex.pm/packages/file_size)

Elixir library to convert colors between different colorspaces.

## Prerequisites

* Erlang 20 or greater
* Elixir 1.8 or greater

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `tint` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:tint, "~> 0.1.0"}
  ]
end
```

## Usage

```elixir
Tint.convert(Tint.RGB.from_hex!("#FFCC00"), Tint.HSV)
```

## Docs

Documentation can be generated with
[ExDoc](https://github.com/elixir-lang/ex_doc) and published on
[HexDocs](https://hexdocs.pm). Once published, the docs can be found at
[https://hexdocs.pm/tint](https://hexdocs.pm/tint).
