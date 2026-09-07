object Words {
	fun reverseString(str: String): String {
		var sb = StringBuilder()
		for (i in (str.length - 1) downTo 0) {
			sb.append(str[i])
		}
		return sb.toString()
	}

	fun isPalindrome(str: String): Boolean {
		val cleanedStr = "\\s+".toRegex().replace(str, "")
		var i = 0
		var j = cleanedStr.length - 1
		while (i < j) {
			if (cleanedStr[i++] != cleanedStr[j--]) {
				return false
			}
		}
		return true
	}

	private fun computeLPSArray(pat: String): IntArray {
		val lenPat = pat.length
		val lps = IntArray(lenPat)
		var i = 1
		var len = 0
		while (i < lenPat) {
			if (pat[i] == pat[len]) {
				len += 1
				lps[i++] = len
			} else {
				if (len != 0) {
					len = lps[len - 1]
				} else {
					lps[i++] = 0
				}
			}
		}
		return lps
	}

	fun kmpSearch(sub: String, str: String): Boolean{
		val lenSub = sub.length
		val lenStr = str.length
		if (lenSub == 0) return true
		if (lenSub > lenStr) return false
		val lps = computeLPSArray(sub)
		var i = 0
		var j = 0
		while (i < lenStr) {
			if (sub[j] == str[i]) {
				i++
				j++
				if (j == lenSub) return true
			} else {
				if (j != 0) {
					j = lps[j - 1]
				} else {
					i++
				}
			}
		}
		return false
	}

	fun lcs(str1: String, str2: String): Int {
		val len1 = str1.length
		val len2 = str2.length
		var dp = Array(len1 + 1) { IntArray(len2 + 1) }
		for (i in 1..len1) {
			for (j in 1..len2) {
				if (str1[i - 1] == str2[j - 1]) {
					dp[i][j] = dp[i - 1][j - 1] + 1
				} else {
					dp[i][j] = Math.max(dp[i - 1][j], dp[i][j - 1])
				}
			}
		}
		return dp[len1][len2]
	}
}