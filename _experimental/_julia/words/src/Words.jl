#!/usr/bin/julia

module Words
export reverse_string, is_palindrome, kmp_search, lcs

function reverse_string(str::String) :: String
  io = IOBuffer(write=true)
  for i = length(str):-1:1
    write(io, str[i])
    i -= 1
  end
  return String(take!(io))
end

function is_palindrome(str::String) :: Bool
  cleaned_str = replace(str, r"\s+" => "")
  i = 1
  j = length(cleaned_str)
  while i < j
    if cleaned_str[i] != cleaned_str[j]
      return false
    end
    i += 1
    j -= 1
  end
  return true
end

function compute_lps_array(pat::String) :: Array{Int,1}
  len_pat = length(pat)
  lps = Array{Int, 1}(undef, len_pat)
  lps[1] = 0
  i = 2
  len = 0
  while i <= len_pat
    if pat[i] == pat[len + 1]
      len += 1
      lps[i] = len
      i += 1
    else
      if len > 0
        len = lps[len]
      else
        lps[i] = 0
        i += 1
      end
    end
  end
  return lps
end

function kmp_search(sub::String, str::String) :: Bool
  len_sub = length(sub)
  len_str = length(str)
  if len_sub == 0
    return true
  elseif len_sub > len_str
    return false
  end
  lps = compute_lps_array(sub)
  i = 1
  j = 1
  while i <= len_str
    if str[i] == sub[j]
      i += 1
      j += 1
      if j > len_sub
        return true
      end
    else
      if j > 1
        j = lps[j - 1]
        if j == 0
          j += 1
        end
      else
        i += 1
      end
    end
  end
  return false
end

function create_matrix(rows::Int, cols::Int)::Array{Int, 2}
  arr = Array{Int, 2}(undef, rows, cols)
  for i in 1:rows
    for j in 1:cols
      arr[i, j] = 0
    end
  end
  return arr
end

function lcs(str1::String, str2::String) :: Int
  len1 = length(str1)
  len2 = length(str2)
  dp = create_matrix(len1 + 1, len2 + 1)
  for i = 2:(len1 + 1)
    for j = 2:(len2 + 1)
      if str1[i - 1] == str2[j - 1]
        dp[i, j] = dp[i - 1, j - 1] + 1
      else
        dp[i, j] = max(dp[i - 1, j], dp[i, j - 1])
      end
    end
  end
  return dp[len1 + 1, len2 + 1]
end

end