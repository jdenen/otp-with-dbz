defmodule Dbz.Character do
  @moduledoc """
  Each GenServer process represents a DBZ character. Each character has a:
  - `name`: The character's name
  - `power_level`: Initial power level
  - `power_increment`: How much the character's power level grows over time
  """
  use GenServer
end
