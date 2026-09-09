open Jest
open Expect

describe("Words functions", () => {
  describe("reverse_string", () => {
    testAll("", list{
      ("hello", "olleh"),
      ("a", "a"),
      ("", "")
    }, ((input, expected)) => {
      expect(Words.reverse_string(input))->toBe(expected)
    })
  })

	describe("is_palindrome", () => {
		testAll("", list{
			("racecar", true),
			("level", true),
			("hello", false),
			("a", true),
			("", true)
		}, ((input, expected)) => {
			expect(Words.is_palindrome(input))->toBe(expected)
		})
	})

	describe("is_substring", () => {
		testAll("", list{
			("test", "this is a test", true),
			("not", "this is a test", false),
			("", "any string", true),
			("abc", "abc", true),
			("abc", "ab", false)
		}, ((substr, str, expected)) => {
			expect(Words.kmp_search(substr, str))->toBe(expected)
		})
	})

	describe("longest_common_subsequence", () => {
		testAll("", list{
			("AGGTAB", "GXTXAYB", 4),
			("ABC", "ABC", 3),
			("ABC", "DEF", 0),
			("", "ABC", 0),
			("ABC", "", 0)
		}, ((str1, str2, expected)) => {
			expect(Words.lcs(str1, str2))->toBe(expected)
		})
	})
})
