import spock.lang.Specification

class WordsSpec extends Specification {

  def setupSpec() {
  }

  def "reverse string"() {
    expect:
    Words.reverseString(s) == result

    where:
    s || result
    "hello" || "olleh"
    "a" || "a"
    "" || ""
  }

  def "is palindrome"() {
    expect:
    Words.isPalindrome(s) == result

    where:
    s || result
    "race car" || true
    "level" || true
    "hello" || false
    "a" || true
    "" || true
  }

  def "is substring"() {
    expect:
    Words.kmpSearch(subst, strng) == result

    where:
    subst || strng || result
    "test" || "this is a test" || true
    "not" || "this is a test" || false
    "" || "any string" || true
    "abc" || "abc" || true
    "abc" || "ab" || false
  }

  def "longest common subsequence"() {
    expect:
    Words.lcs(str1, str2) == result

    where:
    str1 || str2 || result
    "AGGTAB" || "GXTXAYB" || 4
    "ABC" || "ABC" || 3
    "ABC" || "DEF" || 0
    "" || "ABC" || 0
    "ABC" || "" || 0
  }
}