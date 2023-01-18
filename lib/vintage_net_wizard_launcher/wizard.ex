defmodule VintageNetWizardLauncher.Wizard do
  @moduledoc """
  Testing seam for launching the wizard 🧙🏽‍♂️
  """
  @callback start(Keyword.t()) :: :ok | {:error, String.t()}

  @callback start_if_unconfigured(Keyword.t()) :: :ok | {:error, String.t()}

  defmacro __using__(_) do
    impl = if :test == apply(Mix, :env, []), do: FakeWizard, else: VintageNetWizardLauncher

    quote do
      alias unquote(impl), as: Wizard
    end
  end
end
