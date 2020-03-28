defmodule Tint.Distance.CIEDE2000 do
  @moduledoc """
  Implements the CIEDE2000 color distance algorithm as described here:
  http://www2.ece.rochester.edu/~gsharma/ciede2000/ciede2000noteCRNA.pdf
  """

  alias Tint.LCh
  alias Tint.Math

  @pow_25_7 Math.pow(25, 7)

  @spec ciede2000(LCh.t(), LCh.t()) :: float
  def ciede2000(color, other_color) do
    # 2)
    c_star_1 = calc_c_star_i(color.a, color.b)
    c_star_2 = calc_c_star_i(other_color.a, other_color.b)
    # 3)
    c_star_dash = calc_c_star_dash(c_star_1, c_star_2)
    # 4)
    g = calc_g(c_star_dash)
    # 5)
    a_apo_1 = calc_a_apo(g, color.a)
    a_apo_2 = calc_a_apo(g, other_color.a)
    # 6)
    c_apo_1 = calc_c_apo(a_apo_1, color.b)
    c_apo_2 = calc_c_apo(a_apo_2, other_color.b)
    # 7)
    h_apo_1 = calc_h_apo(a_apo_1, color.b)
    h_apo_2 = calc_h_apo(a_apo_2, other_color.b)
    # 8)
    delta_l_apo = Decimal.sub(other_color.lightness, color.lightness)
    # 9)
    delta_c_apo = Decimal.sub(c_star_2, c_star_1)
    # 10)
    delta_h_apo = calc_delta_h_apo(c_apo_1, c_apo_2, h_apo_1, h_apo_2)
    # 11)
    delta_cap_h_apo = calc_delta_cap_h_apo(c_apo_1, c_apo_2, delta_h_apo)
    # 12)
    l_apo_dash = calc_cl_apo_dash(color.lightness, other_color.lightness)
    # 13)
    c_apo_dash = calc_cl_apo_dash(c_apo_1, c_apo_2)
    # 14)
    h_apo_dash = calc_h_apo_dash(c_apo_1, c_apo_2, h_apo_1, h_apo_2)
    # 15)
    t = calc_t(h_apo_dash)
    # 16)
    delta_theta = calc_delta_theta(h_apo_dash)
    # 17)
    rc = calc_rc(c_apo_dash)
    # 18)
    sl = calc_sl(l_apo_dash)
    # 19)
    sc = calc_sc(c_apo_dash)
    # 20)
    sh = calc_sh(c_apo_dash, t)
    # 21)
    rt = calc_rt(delta_theta, rc)
    # 22)
    calc_delta_e00(delta_l_apo, delta_c_apo, delta_cap_h_apo, rt, sl, sc, sh)
  end

  defp calc_c_star_i(a, b) do
    Decimal.sqrt(Decimal.add(Math.pow(a, 2), Math.pow(b, 2)))
  end

  defp calc_c_star_dash(c_star_i, c_star_2) do
    Decimal.div(Decimal.add(c_star_i, c_star_2), 2)
  end

  defp calc_g(c_star_dash) do
    c_star_dash_pow_7 = Math.pow(c_star_dash, 7)

    Decimal.mult(
      "0.5",
      Decimal.sub(
        1,
        Decimal.sqrt(
          Decimal.div(
            c_star_dash_pow_7,
            Decimal.add(c_star_dash_pow_7, @pow_25_7)
          )
        )
      )
    )
  end

  defp calc_a_apo(g, a) do
    Decimal.mult(Decimal.add(1, g), a)
  end

  defp calc_c_apo(a_apo, b) do
    Decimal.sqrt(Decimal.add(Math.pow(a_apo, 2), Math.pow(b, 2)))
  end

  defp calc_h_apo(a_apo, b) do
    if Decimal.eq?(a_apo, 0) && Decimal.eq?(b, 0) do
      0
    else
      b
      |> Math.atan2(a_apo)
      |> Math.rad_to_deg()
    end
  end

  defp calc_delta_h_apo(c_apo_1, c_apo_2, h_apo_1, h_apo_2) do
    if Decimal.eq?(c_apo_1, 0) && Decimal.eq?(c_apo_2, 0) do
      Decimal.new(0)
    else
      diff = Decimal.sub(h_apo_2, h_apo_1)

      cond do
        Decimal.cmp(Decimal.abs(diff), 180) in [:lt, :eq] -> diff
        Decimal.gt?(diff, 180) -> Decimal.sub(diff, 360)
        Decimal.lt?(diff, -180) -> Decimal.add(diff, 360)
      end
    end
  end

  defp calc_delta_cap_h_apo(c_apo_1, c_apo_2, delta_h_apo) do
    2
    |> Decimal.mult(Decimal.sqrt(Decimal.mult(c_apo_1, c_apo_2)))
    |> Decimal.mult(Math.sin(Decimal.div(Math.deg_to_rad(delta_h_apo), 2)))
  end

  defp calc_cl_apo_dash(v1, v2) do
    Decimal.div(Decimal.add(v1, v2), 2)
  end

  defp calc_h_apo_dash(c_apo_1, c_apo_2, h_apo_1, h_apo_2) do
    sum = Decimal.add(h_apo_1, h_apo_2)

    if Decimal.eq?(c_apo_1, 0) && Decimal.eq?(c_apo_2, 0) do
      sum
    else
      abs_diff = Decimal.abs(Decimal.sub(h_apo_1, h_apo_2))

      cond do
        Decimal.cmp(abs_diff, 180) in [:lt, :eq] ->
          Decimal.div(sum, 2)

        Decimal.lt?(sum, 360) ->
          Decimal.div(Decimal.add(sum, 360), 2)

        Decimal.cmp(sum, 360) in [:gt, :eq] ->
          Decimal.div(Decimal.sub(sum, 360), 2)
      end
    end
  end

  defp calc_t(h_apo_dash) do
    h_apo_dash_rad = Math.deg_to_rad(h_apo_dash)

    1
    |> Decimal.sub(
      Decimal.mult(
        "0.17",
        Math.cos(Decimal.sub(h_apo_dash_rad, Math.deg_to_rad(30)))
      )
    )
    |> Decimal.add(
      Decimal.mult("0.24", Math.cos(Decimal.mult(2, h_apo_dash_rad)))
    )
    |> Decimal.add(
      Decimal.mult(
        "0.32",
        Math.cos(
          Decimal.add(
            Decimal.mult(3, h_apo_dash_rad),
            Math.deg_to_rad(6)
          )
        )
      )
    )
    |> Decimal.sub(
      Decimal.mult(
        "0.2",
        Math.cos(
          Decimal.sub(
            Decimal.mult(4, h_apo_dash_rad),
            Math.deg_to_rad(63)
          )
        )
      )
    )
  end

  defp calc_delta_theta(h_apo_dash) do
    Decimal.mult(
      Math.deg_to_rad(30),
      Math.exp(
        Decimal.mult(
          -1,
          Math.pow(
            Decimal.div(
              Decimal.sub(Math.deg_to_rad(h_apo_dash), Math.deg_to_rad(275)),
              Math.deg_to_rad(25)
            ),
            2
          )
        )
      )
    )
  end

  defp calc_rc(c_apo_dash) do
    c_apo_dash_pow_7 = Math.pow(c_apo_dash, 7)

    Decimal.mult(
      2,
      Decimal.sqrt(
        Decimal.div(
          c_apo_dash_pow_7,
          Decimal.add(c_apo_dash_pow_7, @pow_25_7)
        )
      )
    )
  end

  defp calc_sl(l_apo_dash) do
    factor = Math.pow(Decimal.sub(l_apo_dash, 50), 2)

    Decimal.add(
      1,
      Decimal.div(
        Decimal.mult("0.015", factor),
        Decimal.sqrt(Decimal.add(20, factor))
      )
    )
  end

  defp calc_sc(c_apo_dash) do
    Decimal.add(1, Decimal.mult("0.045", c_apo_dash))
  end

  defp calc_sh(c_apo_dash, t) do
    Decimal.add(1, Decimal.mult("0.015", Decimal.mult(c_apo_dash, t)))
  end

  defp calc_rt(delta_theta, rc) do
    -1
    |> Decimal.mult(Math.sin(Decimal.mult(2, delta_theta)))
    |> Decimal.mult(rc)
  end

  defp calc_delta_e00(delta_l_apo, delta_c_apo, delta_h_apo, rt, sl, sc, sh) do
    # The factors kL, kC, and kH are usually unity.
    kl = 1
    kc = 1
    kh = 1

    sc_div = Decimal.mult(kc, sc)
    sh_div = Decimal.mult(kh, sh)

    inner =
      rt
      |> Decimal.mult(Decimal.div(delta_c_apo, sc_div))
      |> Decimal.mult(Decimal.div(delta_h_apo, sh_div))

    0
    |> Decimal.add(Math.pow(Decimal.div(delta_l_apo, Decimal.mult(kl, sl)), 2))
    |> Decimal.add(Math.pow(Decimal.div(delta_c_apo, sc_div), 2))
    |> Decimal.add(Math.pow(Decimal.div(delta_h_apo, sh_div), 2))
    |> Decimal.add(inner)
    |> Decimal.sqrt()
    |> Decimal.to_float()
  end
end
