import re
import numpy as np

def reverse_string(str):
  reversed_str = ""
  for i in range(len(str)-1, -1, -1):
    reversed_str += str[i]
  return reversed_str

def is_palindrome(str):
  cleaned_str = re.sub(r'\s', '', str)
  i = 0
  j = len(cleaned_str) - 1
  while i < j:
    if cleaned_str[i] != cleaned_str[j]:
      return False
    i += 1
    j -= 1
  return True

def __compute_lps_array(pat):
  len_pat = len(pat)
  lps = [0] * len_pat
  length = 0
  i = 1
  while i < len_pat:
    if pat[i] == pat[length]:
      length += 1
      lps[i] = length
      i += 1
    else:
      if length != 0:
        length = lps[length - 1]
      else:
        lps[i] = 0
        i += 1
  return lps

def kmp_search(sub, txt):
  len_sub = len(sub)
  len_txt = len(txt)
  if len_sub == 0:
    return True
  elif len_sub > len_txt:
    return False
  lps = __compute_lps_array(sub)
  i = 0
  j = 0
  while i < len_txt:
    if sub[j] == txt[i]:
      i += 1
      j += 1
      if j == len_sub:
        return True
    else:
      if j != 0:
        j = lps[j - 1]
      else:
        i += 1
  return False

def lcs(str1, str2):
  len1 = len(str1)
  len2 = len(str2)
  dp = np.zeros((len1 + 1, len2 + 1), dtype=int)
  for i in range(1, len1 + 1):
    for j in range(1, len2 + 1):
      if str1[i - 1] == str2[j - 1]:
        dp[i][j] = dp[i - 1][j - 1] + 1
      else:
        dp[i][j] = max(dp[i - 1][j], dp[i][j - 1])
  return dp[len1][len2]