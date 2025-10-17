using GLib;

namespace WordsNS {
	public class Words {
		public static string reverse(string str) {
			StringBuilder sb = new StringBuilder();
			for(int i = str.length - 1; i >= 0; i--) {
				sb.append_c(str[i]);
			}
			return sb.str;
		}

		public static bool palindrome(string str) {
			Regex rgx = /\s/;
			try {
				string cleanedStr = rgx.replace(str, str.length, 0, "");
				int len = cleanedStr.length;
				for(int i = 0; i < cleanedStr.length / 2; i++) {
					if(cleanedStr[i] != cleanedStr[len - i - 1]) return false;
				}
				return true;
			} catch ( GLib.RegexError err) {
				return false;
			}
		}

		private static int[] computeLPSArray(string patt) {
			int lenPatt = patt.length;
			int[] lps = new int[lenPatt];
			int i = 1;
			int len = 0;
			while(i < lenPatt) {
				if(patt[i] == patt[len]) {
					len++;
					lps[i] = len;
					i++;
				} else {
					if(len != 0) {
						len = lps[len - 1];
					} else {
						lps[i] = 0;
						i++;
					}
				}
			}
			return lps;
		}

		public static bool kmpSearch(string sub, string str) {
			int lenSub = sub.length;
			int lenStr = str.length;
			if(lenSub == 0) return true;
			else if(lenSub > lenStr) return false;
			int[] lps = computeLPSArray(sub);
			int i = 0;
			int j = 0;
			while(i < lenStr) {
				if(str[i] == sub[j]) {
					i++;
					j++;
					if(j == lenSub) return true;
				} else {
					if(j != 0) {
						j = lps[j - 1];
					} else {
						i++;
					}
				}
			}
			return false;
		}

		public static int lcs(string str1, string str2) {
			int lenStr1 = str1.length;
			int lenStr2 = str2.length;
			int[,] dp = new int[lenStr1 + 1, lenStr2 + 1];
			for(int i = 1; i <= lenStr1; i++) {
				for(int j = 1; j <= lenStr2; j++) {
					if(str1[i - 1] == str2[j - 1]) {
						dp[i, j] = dp[i - 1, j - 1] + 1;
					} else {
						dp[i, j] = int.max(dp[i - 1, j], dp[i, j - 1]);
					}
				}
			}
			return dp[lenStr1, lenStr2];
		}
	}
}