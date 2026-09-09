require 'minitest/autorun'
require_relative '../src/words'

class WordsTests < Minitest::Test
  def test_reverse_string
    assert_equal 'olleh', Words.reverse_string('hello')
    assert_equal 'a', Words.reverse_string('a')
    assert_equal '', Words.reverse_string('')
  end

  def test_is_palindrome
    assert_equal true, Words.is_palindrome('racecar')
    assert_equal true, Words.is_palindrome('level')
    assert_equal false, Words.is_palindrome('hello')
    assert_equal true, Words.is_palindrome('a')
    assert_equal true, Words.is_palindrome('')
  end

  def test_is_substring
    assert_equal true, Words.kmp_search('test', 'this is a test')
    assert_equal false, Words.kmp_search('not', 'this is a test')
    assert_equal true, Words.kmp_search('', 'any string')
    assert_equal true, Words.kmp_search('abc', 'abc')
    assert_equal false, Words.kmp_search('abc', 'ab')
  end

  def test_lcs
    assert_equal 4, Words.lcs('AGGTAB', 'GXTXAYB')
    assert_equal 3, Words.lcs('ABC', 'ABC')
    assert_equal 0, Words.lcs('ABC', 'DEF')
    assert_equal 0, Words.lcs('', 'ABC')
    assert_equal 0, Words.lcs('ABC', '')
  end
end