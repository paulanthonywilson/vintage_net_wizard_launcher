defmodule VintageNetWizardLauncher.Button do
  @moduledoc """
  GenServer for monitoring the configured (default 21) GPIO pin and launching the wizard if it is set to high for more than 5 seconds
  """

  use GenServer
  use VintageNetWizardLauncher.Gpio
  use VintageNetWizardLauncher.Wizard

  require Logger

  state_keys = [:pin, :gpio]
  @enforce_keys state_keys
  defstruct state_keys

  @name __MODULE__
  @button_down_time :timer.seconds(3)

  def start_link(opts) do
    pin = Keyword.fetch!(opts, :pin)
    GenServer.start(__MODULE__, pin, name: @name)
  end

  def init(pin) do
    {:ok, pin_ref} = Gpio.open(pin, :input)
    :ok = Gpio.set_pull_mode(pin_ref, :pulldown)
    :ok = Gpio.set_interrupts(pin_ref, :both)
    {:ok, %__MODULE__{pin: pin, gpio: pin_ref}}
  end

  def handle_info({:circuits_gpio, pin, _timestamp, 1}, %{pin: pin} = state) do
    Logger.info("Wizard button on pin #{pin} is pressed")
    {:noreply, state, @button_down_time}
  end

  def handle_info({:circuits_gpio, pin, _timestamp, 0}, %{pin: pin} = state) do
    Logger.info("Wizard button on pin #{pin} is released")
    {:noreply, state}
  end

  def handle_info(:timeout, %{pin: pin} = state) do
    :ok = Wizard.start()
    Logger.info("VingageNetWizard started as button on pin #{pin} has been pressed for 3 seconds")
    {:noreply, state}
  end

  def handle_info(msg, state) do
    Logger.debug(fn -> "#{__MODULE__} - unknown message: #{inspect(msg)}" end)
    {:noreply, state}
  end
end
