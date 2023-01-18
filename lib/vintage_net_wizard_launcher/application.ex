defmodule VintageNetWizardLauncher.Application do
  @moduledoc false

  use Application
  use VintageNetWizardLauncher.Wizard
  @default_pin 21

  @impl true
  def start(_type, _args) do
    children = :vintage_net_wizard_launcher |> Application.get_all_env() |> children()

    opts = [strategy: :one_for_one, name: VintageNetWizardLauncher.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def children(opts) do
    []
    |> maybe_add_start_if_unconfigured(opts)
    |> maybe_add_button_monitor(opts)
  end

  defp maybe_add_start_if_unconfigured(children, opts) do
    if Keyword.get(opts, :start_if_unconfigured?, true) do
      [
        %{
          id: StartWizardIfUnconfigured,
          start: {Task, :start_link, [fn -> Wizard.start_if_unconfigured() end]},
          restart: :transient
        }
        | children
      ]
    else
      children
    end
  end

  defp maybe_add_button_monitor(children, opts) do
    pin = Keyword.get(opts, :launch_pin, @default_pin)

    if pin do
      [{VintageNetWizardLauncher.Button, pin: pin} | children]
    else
      children
    end
  end
end
