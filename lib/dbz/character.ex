defmodule Dbz.Character do
  @moduledoc """
  Each GenServer process represents a DBZ character. Each character has a:
  - `name`: The character's name
  - `power_level`: Initial power level
  - `power_increment`: How much the character's power level grows over time
  """
  use GenServer

  require Logger

  def scan(name) do
    power_level = GenServer.call(name, :scan)
    character_name = GenServer.call(name, :character_name)

    "#{character_name}'s power level is #{power_level}"
  end

  def damage(name, amount) do
    GenServer.cast(name, {:damage, amount})
  end

  def kill(name) do
    GenServer.stop(name, :normal)
  end

  def start_link(args) do
    name = Keyword.fetch!(args, :name)
    GenServer.start_link(__MODULE__, args, name: name)
  end

  def child_spec(opts) do
    %{
      id: Keyword.fetch!(opts, :name),
      start: {__MODULE__, :start_link, [opts]},
      restart: :permanent,
      type: :worker
    }
  end

  @impl true
  def init(args) do
    [character_name] = args |> Keyword.fetch!(:name) |> Module.split()

    new_state =
      args
      |> Enum.into(%{})
      |> Map.put(:name, character_name)

    {:ok, new_state, {:continue, :setup_growth}}
  end

  @impl true
  def handle_continue(:setup_growth, state) do
    timer = Process.send_after(self(), :grow, 1000)
    new_state = Map.put(state, :timer, timer)

    {:noreply, new_state}
  end

  @impl true
  def handle_info(:grow, state) do
    new_timer = Process.send_after(self(), :grow, 1000)
    new_power_level = state.power_level + state.power_increment
    new_state = %{state | power_level: new_power_level, timer: new_timer}

    {:noreply, new_state}
  end

  @impl true
  def handle_call(:scan, _from, state), do: {:reply, state.power_level, state}

  def handle_call(:character_name, _from, state), do: {:reply, state.name, state}

  @impl true
  def handle_cast({:damage, amount}, state) do
    new_power_level = state.power_level - amount
    new_state = Map.put(state, :power_level, new_power_level)

    {:noreply, new_state}
  end

  @impl true
  def terminate(_reason, state) do
    Logger.warn("#{state.name} died with a power level of #{state.power_level}")
  end
end
