defmodule VintageNetWizardLauncher.ApplicationTest do
  use ExUnit.Case
  alias VintageNetWizardLauncher.Application

  describe "Button monitoring" do
    test "is started on default pin, by default" do
      assert {VintageNetWizardLauncher.Button, [pin: 21]} ==
               []
               |> Application.children()
               |> find_button_monitor()
    end

    test "is started on configured pin, if present" do
      assert {VintageNetWizardLauncher.Button, [pin: 17]} ==
               [launch_pin: 17]
               |> Application.children()
               |> find_button_monitor()
    end

    test "is disabled if launch pin is falsey" do
      assert nil ==
               [launch_pin: false]
               |> Application.children()
               |> find_button_monitor()
    end
  end

  describe "Wizard starting task" do
    test "is transient and included by default" do
      assert %{start: {Task, :start_link, [_fun]}, restart: :transient} =
               []
               |> Application.children()
               |> find_start_wizard_task()
    end

    test "starts the wizard if unconfigured" do
      %{start: {Task, :start_link, [fun]}} =
        []
        |> Application.children()
        |> find_start_wizard_task()

      fun.()
      assert_received {:start_if_unconfigured, []}
    end

    test "starts the wizard if unconfigured and explicitly configured to do so" do
      assert %{} =
               [start_if_unconfigured?: true]
               |> Application.children()
               |> find_start_wizard_task()
    end

    test "does not start the wizard if unconfigured, when explicitly configured not to do so" do
      assert nil ==
               [start_if_unconfigured?: false]
               |> Application.children()
               |> find_start_wizard_task()
    end
  end

  defp find_button_monitor(child) when is_list(child) do
    Enum.find(child, fn
      {VintageNetWizardLauncher.Button, _} -> true
      _ -> false
    end)
  end

  defp find_start_wizard_task(child) when is_list(child) do
    Enum.find(child, fn
      %{id: StartWizardIfUnconfigured} -> true
      _ -> false
    end)
  end
end
