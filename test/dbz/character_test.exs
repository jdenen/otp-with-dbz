defmodule Dbz.CharacterTest do
  use ExUnit.Case

  alias Dbz.Character

  describe "start_link/1" do
    test "names the character"
    test "works for many names"
    test "allows the character to grow in power"
  end

  describe "scan/1" do
    test "returns the character's power level"
    test "SCREAMS WHEN THE POWER LEVEL IS OVER 9000!!!"
    test "accepts a PID argument"
    test "works for different characters"
  end

  describe "damage/2" do
    test "happens fast"
    test "reduces the character's power level"
  end

  describe "kill/1" do
    test "terminates the character"
  end

  describe "GenServer implementation" do
    test "characters grow over time"
  end
end
