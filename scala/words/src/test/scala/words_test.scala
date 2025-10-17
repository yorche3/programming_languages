import org.scalatest.funsuite.AnyFunSuite

class WordsTest extends AnyFunSuite {
	test("reverse string") {
		assert(Words.reverseString("hello") == "olleh")
		assert(Words.reverseString("a") == "a")
		assert(Words.reverseString("") == "")
	}

	test("is palindrome") {
		assert(Words.isPalindrome("racecar") == true)
		assert(Words.isPalindrome("level") == true)
		assert(Words.isPalindrome("hello") == false)
		assert(Words.isPalindrome("a") == true)
		assert(Words.isPalindrome("") == true)
	}

	test("is substring") {
		assert(Words.kmpSearch("test", "this is a test") == true)
		assert(Words.kmpSearch("not", "this is a test") == false)
		assert(Words.kmpSearch("", "any string") == true)
		assert(Words.kmpSearch("abc", "abc") == true)
		assert(Words.kmpSearch("abc", "ab") == false)
	}

	test("longest common subsequence") {
		assert(Words.lcs("AGGTAB", "GXTXAYB") == 4)
		assert(Words.lcs("ABC", "ABC") == 3)
		assert(Words.lcs("ABC", "DEF") == 0)
		assert(Words.lcs("", "ABC") == 0)
		assert(Words.lcs("ABC", "") == 0)
	}
}
		