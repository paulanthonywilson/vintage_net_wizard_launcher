defmodule VintageNetWizardLauncher.Gpio do
  @moduledoc """
  Indirection behaviour for more nuanced testing of Circuits.GPIO than the built-in NIF stub

  """

  alias Circuits.GPIO

  @callback open(GPIO.pin_number(), GPIO.pin_direction()) :: {:ok, reference()} | {:error, atom()}
  @callback set_interrupts(reference(), GPIO.trigger()) :: :ok | {:error, atom()}
  @callback set_pull_mode(reference(), GPIO.pull_mode()) :: :ok | {:error, atom()}

  defmacro __using__(_) do
    impl = if :test == apply(Mix, :env, []), do: FakeGpio, else: VintageNetWizardLauncher.RealGpio

    quote do
      alias unquote(impl), as: Gpio
    end
  end
end
