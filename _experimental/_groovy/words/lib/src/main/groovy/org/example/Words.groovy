class Words {
  Words() {}

  static String reverseString(String str) {
    def reversed = new StringBuilder()
    for (int i = str.length() - 1; i >= 0; i--) {
      reversed.append(str.charAt(i))
    }
    return reversed.toString()
  }

  static boolean isPalindrome(String str) {
    def cleannedStr = str.replaceAll(/\s/, "")
    def i = 0
    def j = cleannedStr.length() - 1
    while (i < j) {
      if (cleannedStr.charAt(i) != cleannedStr.charAt(j)){
        return false
      }
      i++
      j--
    }
    return true
  }

  private int[] computeLpsArray(String pattern) {
    def lenPattern = pattern.length()
    def lps = new int[lenPattern]
    def i = 1
    def len = 0
    while (i < lenPattern) {
      if (pattern.charAt(i) == pattern.charAt(len)) {
        len++
        lps[i] = len
        i++
      } else {
        if (len > 0) {
          len = lps[len - 1]
        } else {
          lps[i] = 0
          i++
        }
      }
    }
    return lps
  }

  static boolean kmpSearch(String sub, String str) {
    def lenSub = sub.length()
    def lenStr = str.length()
    if (lenSub == 0) {
      return true
    } else if (lenSub > lenStr) {
      return false
    }
    def lps = new Words().computeLpsArray(sub)
    def i = 0
    def j = 0
    while (i < lenStr) {
      if (sub.charAt(j) == str.charAt(i)) {
        j++
        i++
        if (j == lenSub) {
          return true
        }
      } else {
        if (j > 0) {
          j = lps[j - 1]
        } else {
          i++
        }
      }
    }
    return false
  }

  static int lcs(String str1, String str2) {
    def len1 = str1.length()
    def len2 = str2.length()
    def dp = new int[len1 + 1][len2 + 1]
    for (int i = 1; i <= len1; i++) {
      for (int j = 1; j <= len2; j++) {
        if (str1.charAt(i - 1) == str2.charAt(j - 1)) {
          dp[i][j] = dp[i - 1][j - 1] + 1
        } else {
          dp[i][j] = Math.max(dp[i - 1][j], dp[i][j - 1])
        }
      }
    }
    return dp[len1][len2]
  }
}