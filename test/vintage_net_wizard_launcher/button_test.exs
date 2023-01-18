defmodule VintageNetWizardLauncher.ButtonTest do
  use ExUnit.Case
  import ExUnit.CaptureLog
  alias VintageNetWizardLauncher.Button

  import Mox

  setup :verify_on_exit!

  test "launches named, and with configured (default) pin on application start" do
    assert %{pin: 21} = :sys.get_state(Button)
  end

  test "init" do
    pin_ref = :erlang.make_ref()
    set_gpio_pin_ref(pin_ref)

    assert {:ok, %{pin: 17, gpio: ^pin_ref}} = Button.init(17)

    assert_received {:gpio_open, 17, :input}
    assert_received {:gpio_set_interrupts, ^pin_ref, :both}
    assert_received {:gpio_set_pull_mode, ^pin_ref, :pulldown}
  end

  test "sets 3 second timeout when pin goes high" do
    state = %Button{pin: 17, gpio: :erlang.make_ref()}

    log =
      capture_log(fn ->
        assert {:noreply, state, 3_000} ==
                 Button.handle_info({:circuits_gpio, 17, timestamp(), 1}, state)
      end)

    assert log =~ "pressed"
  end

  test "does not set timeout if pin in state does not match message (though this should never happen so this is a bit of belt and braces)" do
    state = %Button{pin: 17, gpio: :erlang.make_ref()}

    assert {:noreply, state} ==
             Button.handle_info({:circuits_gpio, 21, timestamp(), 1}, state)
  end

  test "timeout reset by pin going low" do
    state = %Button{pin: 17, gpio: :erlang.make_ref()}

    log =
      capture_log(fn ->
        assert {:noreply, state} ==
                 Button.handle_info({:circuits_gpio, 17, timestamp(), 0}, state)
      end)

    assert log =~ "released"
  end

  test "runs the wizard on achieving timeout" do
    state = %Button{pin: 17, gpio: :erlang.make_ref()}

    log = capture_log(fn -> assert {:noreply, state} == Button.handle_info(:timeout, state) end)

    assert_received {:wizard_start, []}
    assert log =~ "started"
  end

  defp set_gpio_pin_ref(pin_ref) do
    send(self(), {:fake_gpio_pin_ref, pin_ref})
  end

  # timestamp is ignored
  defp timestamp, do: 0
end
