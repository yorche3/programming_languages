package words

import (
	"regexp"
	"strings"
)

func ReverseString(s string) string {
	var builder strings.Builder
	for i := len(s) - 1; i >= 0; i-- {
		builder.WriteByte(s[i])
	}
	return builder.String()
}

func IsPalindrome(str string) bool {
	ws := regexp.MustCompile(`\s+`)
	cleannedStr := ws.ReplaceAllString(str, "")
	i := 0
	j := len(cleannedStr) - 1
	for i < j {
		if cleannedStr[i] != cleannedStr[j] {
			return false
		}
		i++
		j--
	}
	return true
}

func computeLPSArray(patt string) []int {
	lenPatt := len(patt)
	lps := make([]int, lenPatt)
	i := 1
	len := 0
	for i < lenPatt {
		if patt[i] == patt[len] {
			len++
			lps[i] = len
			i++
		} else {
			if len != 0 {
				len = lps[len-1]
			} else {
				lps[i] = 0
				i++
			}
		}
	}
	return lps
}

func KMPSearch(sub string, str string) bool {
	lenSub := len(sub)
	lenStr := len(str)
	if lenSub == 0 {
		return true
	} else if lenSub > lenStr {
		return false
	}
	lps := computeLPSArray(sub)
	i := 0
	j := 0
	for i < lenStr {
		if str[i] == sub[j] {
			i++
			j++
			if j == lenSub {
				return true
			}
		} else {
			if j != 0 {
				j = lps[j-1]
			} else {
				i++
			}
		}
	}
	return false
}

func max(a, b int) int {
	if a > b {
		return a
	}
	return b
}

func LCS(str1 string, str2 string) int {
	lenStr1 := len(str1)
	lenStr2 := len(str2)
	dp := make([][]int, lenStr1+1)
	for i := 0; i <= lenStr1; i++ {
		dp[i] = make([]int, lenStr2+1)
	}
	for i := 1; i <= lenStr1; i++ {
		for j := 1; j <= lenStr2; j++ {
			if str1[i-1] == str2[j-1] {
				dp[i][j] = dp[i-1][j-1] + 1
			} else {
				dp[i][j] = max(dp[i-1][j], dp[i][j-1])
			}
		}
	}
	return dp[lenStr1][lenStr2]
}
