defmodule Tint.DistanceCache do
  @moduledoc false

  use Agent

  @default_size 3000

  @spec start_link(Keyword.t()) :: Agent.on_start()
  def start_link(opts \\ []) do
    size =
      opts[:size] ||
        Application.get_env(:tint, :distance_cache_size) ||
        @default_size

    Agent.start(
      fn ->
        %{size: size, results: %{}, keys: :queue.new(), count: 0}
      end,
      name: __MODULE__
    )
  end

  @spec get_or_put(term, (() -> number)) :: number
  def get_or_put(key, calc_fun) do
    Agent.get_and_update(__MODULE__, fn
      %{size: 0} = state ->
        {calc_fun.(), state}

      state ->
        case Map.fetch(state.results, key) do
          {:ok, result} ->
            {result, state}

          :error ->
            result = calc_fun.()
            {result, put_result_in_state(state, key, result)}
        end
    end)
  end

  defp put_result_in_state(state, key, result) do
    results = Map.put(state.results, key, result)

    if state.count == state.size do
      {{:value, removed_key}, keys} = :queue.out(state.keys)

      %{
        state
        | results: Map.delete(results, removed_key),
          keys: :queue.in(key, keys)
      }
    else
      %{
        state
        | count: state.count + 1,
          results: results,
          keys: :queue.in(key, state.keys)
      }
    end
  end
end
