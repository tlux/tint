defmodule Tint.Interval do
  @moduledoc """
  An interval of two values with custom boundaries.
  """

  defstruct [:min, :max, exclude_min: false, exclude_max: false]

  @type bound :: :infinity | number

  @type t :: %__MODULE__{
          min: bound,
          max: bound,
          exclude_min: boolean,
          exclude_max: boolean
        }

  @doc false
  @spec new(min :: bound, max :: bound, opts :: Keyword.t()) :: t
  def new(min, max, opts \\ []) do
    struct!(%__MODULE__{min: min, max: max}, opts)
  end

  @doc false
  @spec member?(t, number) :: boolean
  def member?(%__MODULE__{} = interval, value) do
    min_in_interval?(interval, value) &&
      max_in_interval?(interval, value)
  end

  defp min_in_interval?(%{min: :infinity}, _value), do: true
  defp min_in_interval?(%{min: min, exclude_min: true}, value), do: value > min
  defp min_in_interval?(%{min: min}, value), do: value >= min

  defp max_in_interval?(%{max: :infinity}, _value), do: true
  defp max_in_interval?(%{max: max, exclude_max: true}, value), do: value < max
  defp max_in_interval?(%{max: max}, value), do: value <= max

  defimpl String.Chars do
    def to_string(interval) do
      Enum.join([
        start_token(interval.exclude_min),
        sanitize_value(interval.min),
        ",",
        sanitize_value(interval.max),
        end_token(interval.exclude_max)
      ])
    end

    defp sanitize_value(:infinity), do: "Inf"
    defp sanitize_value(value), do: value

    defp start_token(true), do: "("
    defp start_token(false), do: "["

    defp end_token(true), do: ")"
    defp end_token(false), do: "]"
  end
end
