defmodule Tint.Utils.Interval do
  @moduledoc false

  defstruct [:min, :max, exclude_min: false, exclude_max: false]

  @type value :: number | Decimal.t()
  @type bound :: :infinity | value

  @type t :: %__MODULE__{
          min: bound,
          max: bound,
          exclude_min: boolean,
          exclude_max: boolean
        }

  @spec new(min :: bound, max :: bound, opts :: Keyword.t()) :: t
  def new(min, max, opts \\ []) do
    struct(%__MODULE__{min: min, max: max}, opts)
  end

  @spec member?(interval :: t, value) :: boolean
  def member?(%__MODULE__{} = range, value) do
    min_in_range?(range, value) && max_in_range?(range, value)
  end

  defp min_in_range?(%{min: :infinity}, _value), do: true

  defp min_in_range?(%{min: min, exclude_min: true}, value) do
    Decimal.gt?(value, min)
  end

  defp min_in_range?(%{min: min}, value) do
    Decimal.cmp(value, min) in [:gt, :eq]
  end

  defp max_in_range?(%{max: :infinity}, _value), do: true

  defp max_in_range?(%{max: max, exclude_max: true}, value) do
    Decimal.lt?(value, max)
  end

  defp max_in_range?(%{max: max}, value) do
    Decimal.cmp(value, max) in [:lt, :eq]
  end

  defimpl String.Chars do
    def to_string(interval) do
      Enum.join([
        start_token(interval.exclude_min),
        interval.min,
        ",",
        interval.max,
        end_token(interval.exclude_max)
      ])
    end

    defp start_token(true), do: "("
    defp start_token(false), do: "["

    defp end_token(true), do: ")"
    defp end_token(false), do: "]"
  end
end
