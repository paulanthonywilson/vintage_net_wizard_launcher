defmodule FakeWizard do
  @moduledoc false

  @behaviour VintageNetWizardLauncher.Wizard

  @impl true
  def start(opts \\ []) do
    send(self(), {:wizard_start, opts})
    :ok
  end

  @impl true
  def start_if_unconfigured(opts \\ []) do
    send(self(), {:start_if_unconfigured, opts})
    :ok
  end
end
