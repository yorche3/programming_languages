# This is just an example to get you started. A typical library package
# exports the main API in this file. Note that you cannot rename this file
# but you can remove it if you wish.
import re

proc add*(x, y: int): int =
  ## Adds two numbers together.
  return x + y

proc reverseString*(str: string): string =
  var reversed = ""
  for i in countdown(len(str) - 1, 0):
    reversed.add(str[i])
  return reversed

proc isPalindrome*(str: string): bool =
  var cleanedStr = str.replace(re"\s+", "")
  var i = 0
  var j = len(cleanedStr) - 1
  while i < j:
    if cleanedStr[i] != cleanedStr[j]:
      return false
    i += 1
    j -= 1
  return true

proc computeLpsArray*(patt: string): seq[int] =
  let lenPatt = len(patt)
  var lps: seq[int]
  newSeq(lps, lenPatt)
  lps[0] = 0
  var i = 1
  var len = 0
  while i < lenPatt:
    if patt[i] == patt[len]:
      len += 1
      lps[i] = len
      i += 1
    else:
      if len != 0:
        len = lps[len - 1]
      else:
        lps[i] = 0
        i += 1
  return lps

proc kmpSearch*(sub, str: string): bool =
  let lenSub = len(sub)
  let lenStr = len(str)
  if lenSub == 0:
    return true
  elif lenSub > lenStr:
    return false
  let lps = computeLpsArray(sub)
  var i = 0
  var j = 0
  while i < lenStr:
    if str[i] == sub[j]:
      i += 1
      j += 1
      if j == lenSub:
        return true
    else:
      if j != 0:
        j = lps[j - 1]
      else:
        i += 1
  return false

proc lcs*(str1, str2: string): int =
  let len1 = len(str1)
  let len2 = len(str2)
  var dp: seq[seq[int]]
  newSeq(dp, len1 + 1)
  newSeq(dp[0], len2 + 1)
  for i in 1..len1:
    newSeq(dp[i], len2 + 1)
    for j in 1..len2:
      if str1[i - 1] == str2[j - 1]:
        dp[i][j] = dp[i - 1][j - 1] + 1
      else:
        dp[i][j] = max(dp[i - 1][j], dp[i][j - 1])
  return dp[len1][len2]