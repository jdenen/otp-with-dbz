defmodule Dbz.CharacterTest do
  use ExUnit.Case

  import ExUnit.CaptureLog

  alias Dbz.Character

  setup do
    start_supervised!({Character, name: Piccolo, power_level: 100, power_increment: 5})
    :ok
  end

  describe "start_link/1" do
    test "names the character" do
      assert Process.whereis(Piccolo)
    end

    test "works for many names" do
      start_supervised!({Character, name: Gohan, power_level: 10, power_increment: 10})
      assert Process.whereis(Gohan)
    end
  end

  describe "scan/1" do
    test "returns the character's power level" do
      assert Character.scan(Piccolo) == "Piccolo's power level is 100"
    end

    test "accepts a PID argument" do
      pid = Process.whereis(Piccolo)
      assert Character.scan(pid) == "Piccolo's power level is 100"
    end
  end

  describe "damage/2" do
    test "happens fast" do
      assert Character.damage(Piccolo, 10) == :ok
    end

    test "reduces the character's power level" do
      Character.damage(Piccolo, 10)
      assert Character.scan(Piccolo) == "Piccolo's power level is 90"
    end
  end

  describe "kill/1" do
    test "terminates the character" do
      # this isn't the best test demonstrating that the character is terminated
      # but it does emphasize the fact that the character process state is reset
      # when supervision respawns it.
      Character.damage(Piccolo, 50)
      assert Character.scan(Piccolo) == "Piccolo's power level is 50"

      assert :ok = Character.kill(Piccolo)
      assert Character.scan(Piccolo) == "Piccolo's power level is 100"
    end

    test "logs a message on death" do
      msg = "Piccolo died with a power level of 100"
      assert capture_log(fn -> Character.kill(Piccolo) end) =~ msg
    end
  end

  describe "character process" do
    test "grows in power over time" do
      assert Character.scan(Piccolo) == "Piccolo's power level is 100"
      Process.sleep(1001)
      assert Character.scan(Piccolo) == "Piccolo's power level is 105"
    end

    test "handles arbitrary messages"
  end
end
