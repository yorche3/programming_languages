import unittest

import sys
import os
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from src import words

class TestWords(unittest.TestCase):
  def test_reverse_string(self):
    self.assertEqual(words.reverse_string("hello"), "olleh")
    self.assertEqual(words.reverse_string("a"), "a")
    self.assertEqual(words.reverse_string(""), "")

  def test_is_palindrome(self):
    self.assertTrue(words.is_palindrome("race car"))
    self.assertTrue(words.is_palindrome("level"))
    self.assertFalse(words.is_palindrome("hello"))
    self.assertTrue(words.is_palindrome("a"))
    self.assertTrue(words.is_palindrome(""))

  def test_is_substring(self):
    self.assertTrue(words.kmp_search("test", "this is a test"))
    self.assertFalse(words.kmp_search("not", "this is a test"))
    self.assertTrue(words.kmp_search("", "any string"))
    self.assertTrue(words.kmp_search("abc", "abc"))
    self.assertFalse(words.kmp_search("abc", "ab"))

  def test_lcs(self):
    self.assertEqual(words.lcs("AGGTAB", "GXTXAYB"), 4)
    self.assertEqual(words.lcs("ABC", "ABC"), 3)
    self.assertEqual(words.lcs("ABC", "DEF"), 0)
    self.assertEqual(words.lcs("", "ABC"), 0)
    self.assertEqual(words.lcs("ABC", ""), 0)

