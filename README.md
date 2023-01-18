# Vintage Net Wizard Launcher

Automatically launches the [VintageNetWizard](https://hexdocs.pm/vintage_net_wizard/readme.html):-

* On start if there is no WiFi configuration set
* If GPIO pin 21 (or number otherwise configured) is set to high for 3 seconds, ie connected to 3v perhaps by a button press. 

Button monitoring is very close to the [example app](https://github.com/nerves-networking/vintage_net_wizard/blob/v0.4.11/example/lib/wizard_example/button.ex) as that's the sensible way to implement it.


VintageNetWizard will be be included as a dependency with this hexicle only as long as the `Mix.target/0` is not `:host` which will stop awkward attempts to launch when running your tests or developing on your development box. Alternatively if you want
to see it run during development you might want to consider explicitly including it as a dependency and configuring its [fake backend](https://hexdocs.pm/vintage_net_wizard/readme.html#development). 

## Optional Configuration

Change the PIN to (say) 17, with

```elixir
import Config

config :vintage_net_wizard_launcher, launch_pin: 17
```

Stop automatic launching in both cases with

```elixir

config :vintage_net_wizard_launcher, Configuration, launch_pin: false, start_if_unconfigured?: false
```

(Not including this hexicle would also have the same non-result).

## Installation

The package can be installed by adding `vintage_net_wizard_launcher` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:vintage_net_wizard_launcher, "~> 0.1.0"}
  ]
end
```

