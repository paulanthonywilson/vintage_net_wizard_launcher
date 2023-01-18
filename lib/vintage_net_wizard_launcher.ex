defmodule VintageNetWizardLauncher do
  @moduledoc """
  Used to launch the wizard if present
  """

  @behaviour VintageNetWizardLauncher.Wizard

  @doc """
  Call `VintageNetWizard.run_wizard/1` to start the wizard, if available
  """
  @spec start(Keyword.t()) :: :ok | {:error, String.t()}
  def start(opts \\ []) do
    if function_exported?(VintageNetWizard, :run_wizard, 0) do
      apply(VintageNetWizard, :run_wizard, opts)
    else
      :ok
    end
  end

  @doc """
  Call `VintageNetWizard.run_if_unconfigured/1`, if available
  """
  @spec start_if_unconfigured(Keyword.t()) :: :ok | {:error, String.t()}
  def start_if_unconfigured(opts \\ []) do
    if function_exported?(VintageNetWizard, :run_if_unconfigured, 0) do
      apply(VintageNetWizard, :run_if_unconfigured, opts)
    end
  end
end
