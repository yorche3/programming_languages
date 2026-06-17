defmodule Words do
  @moduledoc """
  Documentation for `Words`.
  """
  def reverse_string(str) do
    chars = String.graphemes(str)
    reverse_graphemes(chars)
  end

  defp reverse_graphemes([]), do: ""
  defp reverse_graphemes([ch | tail]), do: reverse_graphemes(tail) <> ch

  def is_palindrome(str) do
    cleaned_str = String.replace(str, ~r/\s+/, "")
    reversed_str = reverse_string(cleaned_str)
    cleaned_str == reversed_str
  end

  def compute_lps_array(patt) do
    len_patt = String.length(patt)
    lps = :array.new(len_patt, default: 0)

    update_lps(1, 0, lps, patt, len_patt)
  end

  defp update_lps(i, len, lps, str, len_str) do
    cond do
      i >= len_str ->
        lps
      :binary.part(str, i, 1) == :binary.part(str, len, 1) ->
        lps_updated = :array.set(i, len + 1, lps)

        update_lps(i + 1, len + 1, lps_updated, str, len_str)
      len > 0 ->
        new_len = :array.get(len - 1, lps)

        update_lps(i, new_len, lps, str, len_str)
      true ->
        lps_updated = :array.set(i, 0, lps)
        update_lps(i + 1, 0, lps_updated, str, len_str)
    end
  end

  def kmp_search(sub, str) do
    len_sub = String.length(sub)
    len_str = String.length(str)

    cond do
      len_sub == 0 -> true
      len_sub > len_str -> false
      true ->
        lps = compute_lps_array(sub)

        kmp_loop(0, 0, sub, str, len_sub, len_str, lps)
    end
  end

  defp kmp_loop(i, j, sub, str, len_sub, len_str, lps) do
    if j == len_sub do
      true
    else
      cond do
        i >= len_str ->
          false
        true ->
          if :binary.part(str, i, 1) == :binary.part(sub, j, 1) do
            kmp_loop(i + 1, j + 1, sub, str, len_sub, len_str, lps)
          else
            if j > 0 do
              new_j = :array.get(j - 1, lps)
              kmp_loop(i, new_j, sub, str, len_sub, len_str, lps)
            else
              kmp_loop(i + 1, j, sub, str, len_sub, len_str, lps)
            end
          end
      end
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

        final_dp = for_i(1, str1, str2, len1, len2, dp)

        :array.get(len1 * (len2 + 1) + len2, final_dp)
    end
  end

  defp for_i(i, str1, str2, len1, len2, dp) do
    cond do
      i > len1 ->
        dp
      true ->
        dp_updated = for_j(i, 1, str1, str2, len1, len2, dp)

        for_i(i + 1, str1, str2, len1, len2, dp_updated)
    end
  end

  defp for_j(i, j, str1, str2, len1, len2, dp) do
    cond do
      j > len2 ->
        dp
      true ->
        if :binary.part(str1, i - 1, 1) == :binary.part(str2, j - 1, 1) do
          new_value = :array.get((i - 1) * (len2 + 1) + (j - 1), dp)
          dp_updated = :array.set(i * (len2 + 1) + j, new_value + 1, dp)

          for_j(i, j + 1, str1, str2, len1, len2, dp_updated)
        else
          val1 = :array.get((i - 1) * (len2 + 1) + j, dp)
          val2 = :array.get(i * (len2 + 1) + (j - 1), dp)
          max_value = max(val1, val2)
          dp_updated = :array.set(i * (len2 + 1) + j, max_value, dp)

          for_j(i, j + 1, str1, str2, len1, len2, dp_updated)
        end

    end
  end
end
