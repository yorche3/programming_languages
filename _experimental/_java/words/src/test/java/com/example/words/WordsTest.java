package com.example.words;

import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.Test;

public class WordsTest {
  @Test
  void testReverseString() {
    assertEquals("olleh", Words.reverseString("hello"));
    assertEquals("a", Words.reverseString("a"));
    assertEquals("", Words.reverseString(""));
  }

  @Test
  void testIsPalindrome() {
    assertTrue(Words.isPalindrome("race car"));
    assertTrue(Words.isPalindrome("level"));
    assertFalse(Words.isPalindrome("hello"));
    assertTrue(Words.isPalindrome("a"));
    assertTrue(Words.isPalindrome(""));
  }

  @Test
  void testKmpSearch() {
    assertTrue(Words.kmpSearch("test", "this is a test"));
    assertFalse(Words.kmpSearch("not", "this is a test"));
    assertTrue(Words.kmpSearch("", "any string"));
    assertTrue(Words.kmpSearch("abc", "abc"));
    assertFalse(Words.kmpSearch("abc", "ab"));
  }

  @Test
  void testLcs() {
    assertEquals(4, Words.lcs("AGGTAB", "GXTXAYB"));
    assertEquals(3, Words.lcs("ABC", "ABC"));
    assertEquals(0, Words.lcs("ABC", "DEF"));
    assertEquals(0, Words.lcs("", "ABC"));
    assertEquals(0, Words.lcs("ABC", ""));
  }

}
