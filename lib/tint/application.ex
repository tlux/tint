defmodule Tint.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Tint.DistanceCache
    ]

    Supervisor.start_link(
      children,
      strategy: :one_for_one,
      name: Tint.Supervisor
    )
  end
end
