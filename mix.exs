defmodule VintageNetWizardLauncher.MixProject do
  use Mix.Project

  def project do
    [
      app: :vintage_net_wizard_launcher,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps(),
      package: package(),
      docs: docs()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {VintageNetWizardLauncher.Application, []}
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.6", only: [:dev, :test]},
      {:dialyxir, "~> 1.2", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.29.1", only: :dev, runtime: false},
      {:mox, "~> 1.0", only: :test},
      {:circuits_gpio, "~> 1.1"}
    ] ++ deps(Mix.target())
  end

  defp deps(:host), do: []

  defp deps(_) do
    [
      {:vintage_net_wizard, "~> 0.4.11"}
    ]
  end

  defp package() do
    [
      description:
        "For Nerves projects, launches the VintageNetWizard if unconfigured and monitors a GPIO button for wizard launching",
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/paulanthonywilson/vintage_net_wizard_launcher/"}
    ]
  end

  defp docs do
    [main: "readme", extras: ["README.md", "CHANGELOG.md"]]
  end

  defp elixirc_paths(:test), do: ["test/support", "lib"]
  defp elixirc_paths(_), do: ["lib"]
end
