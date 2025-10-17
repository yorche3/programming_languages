package;

import haxe.ds.Vector;

class Words {
  public static function reverseString(str: String): String {
    var buff = new StringBuf();
    var len = str.length;
    for (i in 0...len) {
      buff.add(str.charAt(len - i - 1));
    }
    return buff.toString();
  }

  public static function isPalindrome(str: String): Bool {
    var rgx = ~/\s+/g;
    var cleanedStr = rgx.replace(str, "");
    var i = 0;
    var j = cleanedStr.length - 1;
    while (i < j) {
      if (cleanedStr.charAt(i++) != cleanedStr.charAt(j--)) {
        return false;
      }
    }
    return true;
  }

  private static function computeLpsArray(pattern: String): Vector<Int> {
    var lenPattern = pattern.length;
    var lps = new Vector<Int>(lenPattern);
    var i = 1;
    var len = 0;
    lps[0] = 0;
    while (i < lenPattern) {
      if (pattern.charAt(i) == pattern.charAt(len)) {
        len++;
        lps[i++] = len;
      } else {
        if (len > 0) {
          len = lps[len - 1];
        } else {
          lps[i++] = 0;
        }
      }
    }
    return lps;
  }

  public static function kmpSearch(sub: String, str: String): Bool {
    var lenSub = sub.length;
    var lenStr = str.length;
    if (lenSub == 0) {
      return true;
    } else if (lenSub > lenStr) {
      return false;
    }
    var lps = computeLpsArray(sub);
    var i = 0;
    var j = 0;
    while (i < lenStr) {
      if (str.charAt(i) == sub.charAt(j)) {
        i++;
        j++;
        if (j == lenSub) {
          return true;
        }
      } else {
        if (j > 0) {
          j = lps[j - 1];
        } else {
          i++;
        }
      }
    }
    return false;
  }

  private static function max(a: Int, b: Int): Int {
    return a > b ? a : b;
  }

  public static function lcs(str1: String, str2: String): Int {
    var lenStr1 = str1.length;
    var lenStr2 = str2.length;
    var dp = new Vector<Vector<Int>>(lenStr1 + 1);
    for (i in 0...(lenStr1 + 1)) {
      dp[i] = new Vector<Int>(lenStr2 + 1);
      for (j in 0...(lenStr2 + 1)) {
        dp[i][j] = 0;
      }
    }
    for (i in 1...(lenStr1 + 1)) {
      for (j in 1...(lenStr2 + 1)) {
        if (str1.charAt(i - 1) == str2.charAt(j - 1)) {
          dp[i][j] = dp[i - 1][j - 1] + 1;
        } else {
          dp[i][j] = max(dp[i - 1][j], dp[i][j - 1]);
        }
      }
    }
    return dp[lenStr1][lenStr2];
  }
}