defmodule Tint.MixProject do
  use Mix.Project

  @github_url "https://github.com/tlux/tint"

  def project do
    [
      app: :tint,
      version: "1.2.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env()),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test,
        "coveralls.travis": :test
      ],
      dialyzer: [plt_add_apps: [:ex_unit, :mix]],
      description: description(),
      package: package(),
      aliases: aliases(),
      dialyzer: dialyzer(),

      # Docs
      name: "Tint",
      source_url: @github_url,
      docs: [
        main: "readme",
        extras: [
          "LICENSE.md": [title: "License"],
          "README.md": [title: "Readme"]
        ],
        groups_for_modules: [
          Colorspaces: [
            Tint.CMYK,
            Tint.DIN99,
            Tint.HSV,
            Tint.Lab,
            Tint.RGB,
            Tint.XYZ
          ],
          "Color Distance": [
            Tint.Distance,
            Tint.Distance.CIEDE2000,
            Tint.Distance.Euclidean
          ],
          Utility: [
            Tint.Interval
          ]
        ]
      ]
    ]
  end

  defp aliases do
    [
      test: "test --no-start"
    ]
  end

  def application do
    [
      extra_applications: [],
      mod: {Tint.Application, []},
      registered: [
        Tint.DistanceCache
      ]
    ]
  end

  defp description do
    "A library allowing calculations with colors and conversions between " <>
      "different colorspaces."
  end

  defp deps do
    [
      {:benchee, "~> 1.0", only: :dev},
      {:castore, "~> 1.0", only: :test, runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.18", only: :test},
      {:ex_doc, "~> 0.31", only: :dev, runtime: false},
      {:mix_audit, "~> 2.1", only: [:dev, :test]}
    ]
  end

  defp dialyzer do
    [
      plt_add_apps: [:ex_unit],
      plt_add_deps: :app_tree,
      plt_file: {:no_warn, "priv/plts/tint.plt"}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp package do
    [
      licenses: ["MIT"],
      links: %{
        "GitHub" => @github_url
      }
    ]
  end
end
