defmodule Tint.LCh do
  @moduledoc since: "0.4.0"

  import Tint.Utils

  alias Tint.Distance
  alias Tint.LCh.Convertible
  alias Tint.Math

  defstruct [:lightness, :a, :b, :chroma, :hue]

  @type t :: %__MODULE__{
          lightness: Decimal.t(),
          a: Decimal.t(),
          b: Decimal.t(),
          chroma: Decimal.t(),
          hue: Decimal.t()
        }

  # https://de.wikipedia.org/wiki/LCh-Farbraum
  # https://en.wikipedia.org/wiki/Color_difference#CIEDE2000

  @spec new(
          float | Decimal.decimal(),
          float | Decimal.decimal(),
          float | Decimal.decimal(),
          float | Decimal.decimal(),
          float | Decimal.decimal()
        ) :: t
  def new(lightness, a, b, chroma, hue) do
    case cast_degrees(hue) do
      {:ok, hue} ->
        %__MODULE__{
          lightness: cast_value(lightness),
          a: cast_value(a),
          b: cast_value(b),
          chroma: cast_value(chroma),
          hue: hue
        }

      {:error, error} ->
        raise error
    end
  end

  defp cast_value(value) do
    value
    |> Decimal.cast()
    |> Decimal.round(3)
  end

  @doc """
  Finds the nearest color for the specified color using the given color palette
  and an optional distance algorithm.
  """
  @doc since: "0.2.0"
  @spec nearest(t, [Convertible.t()], (t, t -> number)) ::
          nil | Convertible.t()
  def nearest(
        %__MODULE__{} = color,
        palette,
        distance_algorithm \\ &delta_e_ciede2000/2
      ) do
    Distance.nearest(color, palette, &Convertible.to_lch/1, distance_algorithm)
  end

  @pow_25_7 Math.pow(25, 7)

  @spec delta_e_ciede2000(t, Convertible.t()) :: float
  def delta_e_ciede2000(%__MODULE__{} = color, other_color) do
    other_color = Convertible.to_lch(other_color)

    delta_l = Decimal.sub(other_color.lightness, color.lightness)

    l_dash =
      color.lightness
      |> Decimal.add(other_color.lightness)
      |> Decimal.div(2)

    c_dash = color.chroma |> Decimal.add(other_color.chroma) |> Decimal.div(2)

    apo_factor =
      Decimal.sub(
        1,
        Decimal.sqrt(
          Decimal.div(
            Math.pow(c_dash, 7),
            Decimal.add(Math.pow(c_dash, 7), @pow_25_7)
          )
        )
      )

    # a_apo_1 = calc_a_apo(color, apo_factor)
    # a_apo_2 = calc_a_apo(other_color, apo_factor)

    c_apo_1 = calc_c_apo(color)
    c_apo_2 = calc_c_apo(other_color)
    c_dash = Decimal.div(Decimal.add(c_apo_1, c_apo_2), 2)
    delta_c = Decimal.sub(c_apo_2, c_apo_1)

    h_apo_1 =
      if Decimal.eq?(c_apo_1, 0) do
        # The inverse tangent is indeterminate if the corresponding C' is zero);
        # in that case, set the hue angle to zero.
        Decimal.new(0)
      else
        calc_h_apo(color)
      end

    h_apo_2 =
      if Decimal.eq?(c_apo_2, 0) do
        # The inverse tangent is indeterminate if the corresponding C' is zero);
        # in that case, set the hue angle to zero.
        Decimal.new(0)
      else
        calc_h_apo(other_color)
      end

    delta_h =
      if Decimal.eq?(c_apo_1, 0) || Decimal.eq?(c_apo_2, 0) do
        # When either C′1 or C′2 is zero, then Δh′ is irrelevant and may be set
        # to zero.
        Decimal.new(0)
      else
        calc_delta_h(h_apo_1, h_apo_2)
      end

    delta_cap_h = calc_delta_cap_h(delta_h, c_apo_1, c_apo_2)

    cap_h_dash =
      if Decimal.eq?(c_apo_1, 0) || Decimal.eq?(c_apo_2, 0) do
        # When either C'1 or C'2 is zero, then H' is h'1+h'2 (no divide by 2;
        # essentially, if one angle is indeterminate, then use the other angle
        # as the average; relies on indeterminate angle being set to zero)
        Decimal.add(h_apo_1, h_apo_2)
      else
        calc_cap_h_dash(h_apo_1, h_apo_2)
      end

    t = calc_t(cap_h_dash)
    sl = calc_sl(l_dash)
    sc = calc_sc(c_dash)
    sh = calc_sh(c_dash, t)
    rt = calc_rt(c_dash, cap_h_dash)

    calc_delta_e00(delta_l, delta_c, delta_cap_h, rt, sl, sc, sh)
  end

  defp calc_delta_e00(delta_l, delta_c, delta_h, rt, sl, sc, sh) do
    # The factors kL, kC, and kH are usually unity.
    kl = 1
    kc = 1
    kh = 1

    sc_div = Decimal.mult(kc, sc)
    sh_div = Decimal.mult(kh, sh)

    inner =
      rt
      |> Decimal.mult(Decimal.div(delta_c, sc_div))
      |> Decimal.mult(Decimal.div(delta_h, sh_div))

    0
    |> Decimal.add(Math.pow(Decimal.div(delta_l, Decimal.mult(kl, sl)), 2))
    |> Decimal.add(Math.pow(Decimal.div(delta_c, sc_div), 2))
    |> Decimal.add(Math.pow(Decimal.div(delta_h, sh_div), 2))
    |> Decimal.add(inner)
    |> Decimal.sqrt()
  end

  # defp calc_a_apo(color, apo_factor) do
  #   Decimal.add(color.a, Decimal.mult(Decimal.div(color.a, 2), apo_factor))
  # end

  defp calc_c_apo(color) do
    Decimal.sqrt(Decimal.add(Math.pow(color.a, 2), Math.pow(color.b, 2)))
  end

  defp calc_h_apo(color) do
    color.b
    |> Math.atan2(color.a)
    |> Math.rad_to_deg()
    |> Math.rem(360)
  end

  defp calc_delta_h(h_apo_1, h_apo_2) do
    diff = Decimal.sub(h_apo_2, h_apo_1)
    abs_diff = Decimal.abs(Decimal.sub(h_apo_1, h_apo_2))

    cond do
      Decimal.cmp(abs_diff, 180) in [:lt, :eq] ->
        diff

      Decimal.cmp(h_apo_2, h_apo_1) in [:lt, :eq] ->
        Decimal.add(diff, 360)

      true ->
        Decimal.sub(diff, 360)
    end
  end

  defp calc_delta_cap_h(delta_h, c_apo_1, c_apo_2) do
    Decimal.mult(
      Decimal.sqrt(Decimal.mult(c_apo_1, c_apo_2)),
      Math.sin(Decimal.div(delta_h, 2))
    )
  end

  defp calc_cap_h_dash(h_apo_1, h_apo_2) do
    abs_diff = Decimal.abs(Decimal.sub(h_apo_1, h_apo_2))

    cond do
      Decimal.cmp(abs_diff, 180) in [:lt, :eq] ->
        Decimal.add(h_apo_1, h_apo_2)

      Decimal.lt?(Decimal.add(h_apo_1, h_apo_2), 360) ->
        h_apo_1
        |> Decimal.add(h_apo_2)
        |> Decimal.add(360)
        |> Decimal.div(2)

      true ->
        h_apo_1
        |> Decimal.add(h_apo_2)
        |> Decimal.sub(360)
        |> Decimal.div(2)
    end
  end

  defp calc_t(cap_h_dash) do
    1
    |> Decimal.sub(Decimal.mult("0.17", Math.cos(Decimal.sub(cap_h_dash, 30))))
    |> Decimal.add(Decimal.mult("0.24", Math.cos(Decimal.mult(2, cap_h_dash))))
    |> Decimal.add(
      Decimal.mult(
        "0.32",
        Math.cos(Decimal.add(Decimal.mult(3, cap_h_dash), 6))
      )
    )
    |> Decimal.sub(
      Decimal.mult(
        "0.2",
        Math.cos(Decimal.sub(Decimal.mult(4, cap_h_dash), 63))
      )
    )
  end

  defp calc_sl(l_dash) do
    inner = Math.pow(Decimal.sub(l_dash, 50), 2)

    Decimal.add(
      1,
      Decimal.div(
        Decimal.mult("0.015", inner),
        Decimal.sqrt(Decimal.add(20, inner))
      )
    )
  end

  defp calc_sc(c_dash) do
    Decimal.add(1, Decimal.mult("0.045", c_dash))
  end

  defp calc_sh(c_dash, t) do
    "0.015"
    |> Decimal.mult(c_dash)
    |> Decimal.mult(t)
    |> Decimal.add(1)
  end

  defp calc_rt(c_dash, h_dash) do
    c_dash_pow_7 = Math.pow(c_dash, 7)

    -2
    |> Decimal.mult(
      Decimal.sqrt(Decimal.div(c_dash_pow_7, Decimal.add(c_dash_pow_7, 25)))
    )
    |> Decimal.mult(
      Math.sin(
        Decimal.mult(
          60,
          Math.exp(
            Decimal.mult(
              -1,
              Math.pow(Decimal.div(Decimal.sub(h_dash, 275), 25), 2)
            )
          )
        )
      )
    )
  end
end
