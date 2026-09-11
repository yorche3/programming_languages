defmodule WordsIter do
  @moduledoc """
  Documentation for `Words`.
  """
  def reverse_string(str) do
    chars = String.graphemes(str)
    len = length(chars)

    0..(len - 1)
    |> Enum.reduce([], fn i, acc ->
        [Enum.at(chars, i) | acc]
      end)
    |> Enum.join()
  end

  def is_palindrome(str) do
    cleaned_str = String.replace(str, ~r/\s+/, "")
    chars = String.graphemes(cleaned_str)
    len = length(chars)

    0..div(len, 2)
    |> Enum.reduce_while(true, fn i, _acc ->
        if Enum.at(chars, i) != Enum.at(chars, -i - 1) do
          {:halt, false}
        else
          {:cont, true}
        end
      end)
  end

  def compute_lps_array(patt) do
    len_patt = String.length(patt)
    lps = :array.new(len_patt, default: 0)

    {lps, _} =
      1..(len_patt - 1)
      |> Enum.reduce({lps, 0}, fn i, {lps_, len} ->
        if String.at(patt, i) == String.at(patt, len) do
          len = len + 1
          lps_ = :array.set(i, len, lps_)
          {lps_, len}
        else
          if len != 0 do
            len = :array.get(len - 1, lps_)
            {lps_, len}
          else
            lps_ = :array.set(i, 0, lps_)
            {lps_, 0}
          end
        end
      end)
    lps
  end

  def kmp_search(sub, str) do
    len_sub = String.length(sub)
    len_str = String.length(str)

    cond do
      len_sub == 0 -> true
      len_sub > len_str -> false
      true ->
        lps = compute_lps_array(sub)

        result = Enum.reduce_while(0..len_str, {0, false}, fn i, {j, _} ->
          cond do
            i >= len_str -> {:halt, false}
            true ->
              if String.at(str, i) == String.at(sub, j) do
                j_new = j + 1
                if j_new == len_sub do
                  {:halt, true}
                else
                  {:cont, {j_new, false}}
                end
              else
                if j != 0 do
                  {:cont, {:array.get(j - 1, lps), false}}
                else
                  {:cont, {0, false}}
                end
              end
          end
        end)

        result
    end
  end

  def lcs(str1, str2) do
    len1 = String.length(str1)
    len2 = String.length(str2)

    cond do
      len1 == 0 || len2 == 0 ->
        0
      true ->
        dp = :array.new((len1 + 1) * (len2 + 1), default: 0)

        # Helper to access dp cells
        get_dp = fn i, j, array ->
          :array.get(i * (len2 + 1) + j, array)
        end

        # Helper to set dp cells, returns new array
        set_dp = fn i, j, val, array ->
          :array.set(i * (len2 + 1) + j, val, array)
        end

        final_dp =
          1..len1
          |> Enum.reduce(dp, fn i, acc_dp ->
            1..len2
            |> Enum.reduce(acc_dp, fn j, acc_dp2 ->
              if String.at(str1, i - 1) == String.at(str2, j - 1) do
                prev_ = get_dp.(i - 1, j - 1, acc_dp2)
                set_dp.(i, j, prev_ + 1, acc_dp2)
              else
                l_ = get_dp.(i - 1, j, acc_dp2)
                r_ = get_dp.(i, j - 1, acc_dp2)
                max_value_ = if l_ > r_, do: l_, else: r_
                set_dp.(i, j, max_value_, acc_dp2)
              end
            end)
          end)

        # Return the value at bottom-right of DP
        :array.get(len1 * (len2 + 1) + len2, final_dp)
    end
  end
end
