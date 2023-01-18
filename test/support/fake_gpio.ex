defmodule FakeGpio do
  @moduledoc """
  Used instead of Mox, as that does not play well with being called during application start
  """

  @behaviour VintageNetWizardLauncher.Gpio

  @impl true
  def open(pin_number, direction) do
    send(self(), {:gpio_open, pin_number, direction})

    ref =
      receive do
        {:fake_gpio_pin_ref, ref} ->
          ref
      after
        1 ->
          :erlang.make_ref()
      end

    {:ok, ref}
  end

  @impl true
  def set_interrupts(pin_ref, types) do
    send(self(), {:gpio_set_interrupts, pin_ref, types})
    :ok
  end

  @impl true
  def set_pull_mode(pin_ref, mode) do
    send(self(), {:gpio_set_pull_mode, pin_ref, mode})
    :ok
  end
end
