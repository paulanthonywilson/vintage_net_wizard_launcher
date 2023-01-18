defmodule VintageNetWizardLauncher.RealGpio do
  @moduledoc """
  Forwards to actual `Circuits.GPIO`
  """
  @behaviour VintageNetWizardLauncher.Gpio
  alias Circuits.GPIO

  @impl true
  defdelegate open(pin_number, direction), to: GPIO

  @impl true
  defdelegate set_interrupts(pin_ref, trigger), to: GPIO

  @impl true
  defdelegate set_pull_mode(pin_ref, pull_mode), to: GPIO
end
