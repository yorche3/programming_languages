import Foundation

public struct Words {
	public static func stringReverse(str: String) -> String {
		var reversed = ""
		var i = str.count - 1
		while i >= 0 {
			let index = str.index(str.startIndex, offsetBy: i)
			reversed.append(str[index])
			i -= 1
		}
		return reversed
	}

	public static func isPalindrome(str: String) -> Bool {
		let cleanedStr = str.replacingOccurrences(of: "\\s", with: "", options: .regularExpression)
		let len = cleanedStr.count
		if len <= 1 { return true }
		var i = 0
		var j = len - 1
		while i < j {
			let indexI = cleanedStr.index(cleanedStr.startIndex, offsetBy: i)
			let indexJ = cleanedStr.index(cleanedStr.startIndex, offsetBy: j)
			if cleanedStr[indexI] != cleanedStr[indexJ] { return false }
			i += 1
			j -= 1
		}
		return true
	}

	static func computeLpsArray(patt: String) -> [Int] {
		let lenPatt = patt.count
		var lps = [Int](repeating: 0, count: lenPatt)
		var i = 1
		var len = 0
		while i < lenPatt {
			let indexI = patt.index(patt.startIndex, offsetBy: i)
			let indexLen = patt.index(patt.startIndex, offsetBy: len)
			if patt[indexI] == patt[indexLen] {
				len += 1
				lps[i] = len
				i += 1
			} else {
				if len != 0 {
					len = lps[len - 1]
				} else {
					lps[i] = 0
					i += 1
				}
			}
		}
		return lps
	}

	public static func kmpSearch(sub: String, str: String) -> Bool {
		let lenSub = sub.count
		let lenStr = str.count
		if lenSub == 0 { return true }
		if lenSub > lenStr { return false }
		let lps = computeLpsArray(patt: sub)
		var i = 0
		var j = 0
		while i < lenStr {
			let indexI = str.index(str.startIndex, offsetBy: i)
			let indexJ = sub.index(sub.startIndex, offsetBy: j)
			if str[indexI] == sub[indexJ] {
				i += 1
				j += 1
				if j == lenSub { return true }
			} else {
				if j != 0 {
					j = lps[j - 1]
				} else {
					i += 1
				}
			}
		}
		return false
	}

	public static func lcs(str1: String, str2: String) -> Int {
		let str1Len = str1.count
		let str2Len = str2.count
		if str1Len == 0 || str2Len == 0 { return 0 }
		var dp = Array(repeating: Array(repeating: 0, count: (str2Len + 1)), count: (str1Len + 1))
		for i in 1...str1Len {
			for j in 1...str2Len {
				let indexI = str1.index(str1.startIndex, offsetBy: (i - 1))
				let indexJ = str2.index(str2.startIndex, offsetBy: (j - 1))
				if str1[indexI] == str2[indexJ] {
					dp[i][j] = dp[i - 1][j - 1] + 1
				} else {
					dp[i][j] = max(dp[i - 1][j], dp[i][j - 1])
				}
			}
		}
		return dp[str1Len][str2Len]
	}
}