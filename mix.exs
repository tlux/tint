defmodule Tint.MixProject do
  use Mix.Project

  def project do
    [
      app: :tint,
      version: "0.3.1",
      elixir: "~> 1.7",
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

      # Docs
      name: "Tint",
      source_url: "https://github.com/tlux/tint",
      docs: [
        main: "readme",
        extras: ["README.md"],
        groups_for_modules: [
          Colorspaces: [
            Tint.Lab,
            Tint.CMYK,
            Tint.HSV,
            Tint.RGB
          ]
        ]
      ]
    ]
  end

  def application do
    [
      extra_applications: []
    ]
  end

  defp description do
    "A library allowing calculations with colors and conversions between " <>
      "different colorspaces."
  end

  defp deps do
    [
      {:credo, "~> 1.0.5", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0.0-rc.6", only: [:dev, :test], runtime: false},
      {:decimal, "~> 1.0"},
      {:excoveralls, "~> 0.10", only: :test},
      {:ex_doc, "~> 0.20.2", only: :dev, runtime: false},
      {:inch_ex, "~> 2.0", only: :docs}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp package do
    [
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/tlux/tint"
      }
    ]
  end
end
