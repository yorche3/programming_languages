using GLib;
using WordsNS;

namespace TestSuites {
	public class WordsTest {
		public static void addTests() {
			Test.add_func("/Words/reverse", () => {
				assert("olleh" == Words.reverse("hello"));
				assert("a" == Words.reverse("a"));
				assert("" == Words.reverse(""));
			});

			Test.add_func("/Words/palindrome", () => {
				assert(true == Words.palindrome("race car"));
				assert(true == Words.palindrome("level"));
				assert(false == Words.palindrome("hello"));
				assert(true == Words.palindrome("a"));
				assert(true == Words.palindrome(""));
			});

			Test.add_func("/Words/substring", () => {
				assert(true == Words.kmpSearch("test", "this is a test"));
				assert(false == Words.kmpSearch("not", "this is a test"));
				assert(true == Words.kmpSearch("", "any string"));
				assert(true == Words.kmpSearch("abc", "abc"));
				assert(false == Words.kmpSearch("abc", "ab"));
			});

			Test.add_func("/Words/lcs", () => {
				assert(4 == Words.lcs("AGGTAB", "GXTXAYB"));
				assert(3 == Words.lcs("ABC", "ABC"));
				assert(0 == Words.lcs("ABC", "DEF"));
				assert(0 == Words.lcs("", "ABC"));
				assert(0 == Words.lcs("ABC", ""));
			});
		}
	}
}