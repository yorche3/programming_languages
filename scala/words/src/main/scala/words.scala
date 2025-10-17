class Words {}

object Words {
	def reverseString(str: String): String = {
		val sb = new StringBuilder()
		for (i <- str.length - 1 to 0 by -1) {
			sb.append(str(i))
		}
		sb.toString()
	}

	def isPalindrome(str: String): Boolean = {
		val cleanedStr = str.replaceAll("\\s", "")
		var i = 0
		var j = cleanedStr.length() - 1
		while (i < j) {
			if (cleanedStr(i) != cleanedStr(j)) {
				return false
			}
			i += 1
			j -= 1
		}
		true
	}

	private def computeLPSArray(pat: String): Array[Int] = {
		val lenPat = pat.length
		val lps = new Array[Int](lenPat)
		var i = 1
		var len = 0
		while (i < lenPat) {
			if (pat(i) == pat(len)) {
				len += 1
				lps(i) = len
				i += 1
			} else {
				if (len != 0) {
					len = lps(len - 1)
				} else {
					lps(i) = 0
					i += 1
				}
			}
		}
		lps
	}

	def kmpSearch(sub: String, str: String): Boolean = {
		val lenSub = sub.length
		val lenStr = str.length
		if (lenSub == 0) return true
		if (lenSub > lenStr) return false
		val lps = computeLPSArray(sub)
		var i = 0
		var j = 0
		while (i < lenStr) {
			if (sub(j) == str(i)) {
				i += 1
				j += 1
				if (j == lenSub) return true
			} else {
				if (j != 0) {
					j = lps(j - 1)
				} else {
					i += 1
				}
			}
		}
		false
	}

	def lcs(str1: String, str2: String): Int = {
		val len1 = str1.length
		val len2 = str2.length
		val dp: Array[Array[Int]] = Array.ofDim(len1 + 1, len2 + 1)
		for (i <- 1 to len1) {
			for (j <- 1 to len2) {
				if (str1(i - 1) == str2(j - 1)) {
					dp(i)(j) = dp(i - 1)(j - 1) + 1
				} else {
					dp(i)(j) = Math.max(dp(i - 1)(j), dp(i)(j - 1))
				}
			}
		}
		dp(len1)(len2)
	}
}