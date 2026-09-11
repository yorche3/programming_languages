package com.example.words;

public class Words {
  public static String reverseString(String str)
	{
		StringBuilder sb = new StringBuilder();
		for (int i = str.length() - 1; i >= 0; i--) {
			sb.append(str.charAt(i));
		}
		return sb.toString();
	}

	public static boolean isPalindrome(String str)
	{
		String cleannedStr = str.replaceAll("\\s", "");
		int i = 0;
		int j = cleannedStr.length() - 1;
		while (i < j) {
			if (cleannedStr.charAt(i) != cleannedStr.charAt(j)) {
				return false;
			}
			i++;
			j--;
		}
		return true;
	}

	private static int[] computeLPSArray(String pat)
	{
		int lenPat = pat.length();
		int lps[] = new int[lenPat];
		int i = 1;
		int len = 0;
		while (i < lenPat) {
			if (pat.charAt(i) == pat.charAt(len)) {
				len++;
				lps[i] = len;
				i++;
			} else {
				if (len != 0) {
					len = lps[len - 1];
				} else {
					lps[i] = 0;
					i++;
				}
			}
		}
		return lps;
	}

	public static boolean kmpSearch(String sub, String str)
	{
		int lenSub = sub.length();
		int lenStr = str.length();
		if (lenSub == 0) {
			return true;
		} else if (lenSub > lenStr) {
			return false;
		}
		int[] lps = computeLPSArray(sub);
		int i = 0;
		int j = 0;
		while (i < lenStr) {
			if (sub.charAt(j) == str.charAt(i)) {
				j++;
				i++;
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

	public static int lcs(String str1, String str2)
	{
		int len1 = str1.length();
		int len2 = str2.length();
		int dp[][] = new int[len1 + 1][len2 + 1];
		for (int i = 1; i <= len1; i++) {
			for (int j = 1; j <= len2; j++) {
				if (str1.charAt(i - 1) == str2.charAt(j - 1)) {
					dp[i][j] = dp[i - 1][j - 1] + 1;
				} else {
					dp[i][j] = Math.max(dp[i - 1][j], dp[i][j - 1]);
				}
			}
		}
		return dp[len1][len2];
	}
}
