defmodule Axiom do
  use GenServer

  def init(state) do
    {:ok, %{delta: state, phi: 0}}
  end

  def handle_cast(:oscillate, state) do
    new_phi = :erlang.phash2(state.delta, 0xFFFFFFFF)
    {:noreply, %{delta: new_phi, phi: state.phi + 1}}
  end

  def handle_call(:read, _from, state) do
    {:reply, {state.phi, state.delta}, state}
  end

  def spawn_cluster(n) do
    1..n |> Enum.map(fn i ->
      {:ok, pid} = GenServer.start_link(__MODULE__, i * 999)
      send(pid, :oscillate)
      pid
    end)
  end
end