import 'dart:math';

class Words {
  static String reverseString(String str) {
    List<String> chars = str.split('');
    int i = 0;
    int j = chars.length - 1;
    String c;
    while (i < j) {
      c = chars[i];
      chars[i] = chars[j];
      chars[j] = c;
      i++;
      j--;
    }
    return chars.join('');
  }

  static bool isPalindrome(String str) {
    String cleanedString = str.replaceAll(RegExp(r'\s+'), '');
    int i = 0;
    int j = cleanedString.length - 1;
    while (i < j) {
      if (cleanedString[i++] != cleanedString[j--]) {
        return false;
      }
    }
    return true;
  }

  static List<int> _computeLPSArray(String patt) {
    int lenPatt = patt.length;
    List<int> lps = List.filled(lenPatt, 0);
    int i = 1;
    int len = 0;
    while (i < lenPatt) {
      if (patt[i] == patt[len]) {
        len++;
        lps[i++] = len;
      } else {
        if (len != 0) {
          len = lps[len - 1];
        } else {
          i++;
        }
      }
    }
    return lps;
  }

  static bool kmpSearch(String sub, String str) {
    int lenSub = sub.length;
    int lenStr = str.length;
    if (lenSub == 0) {
      return true;
    } else if (lenSub > lenStr) {
      return false;
    }
    int i = 0;
    int j = 0;
    List<int> lps = _computeLPSArray(sub);
    while (i < lenStr) {
      if (str[i] == sub[j]) {
        i++;
        j++;
        if (j == lenSub) {
          return true;
        }
      } else {
        if (j != 0) {
          j = lps[j - 1];
        } else {
          i++;
        }
      }
    }
    return false;
  }

  static int lcs(String str1, String str2) {
    int lenStr1 = str1.length;
    int lenStr2 = str2.length;
    List<List<int>> dp = List.generate(lenStr1 + 1, (_) => List.filled(lenStr2 + 1, 0));
    for (var i = 1; i <= lenStr1; i++) {
      for (var j = 1; j <= lenStr2; j++) {
        if (str1[i - 1] == str2[j - 1]) {
          dp[i][j] = dp[i - 1][j - 1] + 1;
        } else {
          dp[i][j] = max(dp[i - 1][j], dp[i][j - 1]);
        }
      }
    }
    return dp[lenStr1][lenStr2];
  }
}