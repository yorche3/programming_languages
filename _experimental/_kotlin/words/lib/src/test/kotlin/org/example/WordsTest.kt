package org.example

import kotlin.test.Test
import kotlin.test.assertTrue
import kotlin.test.assertEquals

class WordsTest {
    @Test fun testReverseString() {
        assertEquals("olleh", Words.reverseString("hello"))
        assertEquals("a", Words.reverseString("a"))
        assertEquals("", Words.reverseString(""))
    }

    @Test fun testIsPalindrome() {
        assertTrue(Words.isPalindrome("race car"))
        assertTrue(Words.isPalindrome("level"))
        assertTrue(!Words.isPalindrome("hello"))
        assertTrue(Words.isPalindrome("a"))
        assertTrue(Words.isPalindrome(""))
    }

    @Test fun testIsSubstring() {
        assertTrue(Words.kmpSearch("test", "this is a test"))
        assertTrue(!Words.kmpSearch("not", "this is a test"))
        assertTrue(Words.kmpSearch("", "any string"))
        assertTrue(Words.kmpSearch("abc", "abc"))
        assertTrue(!Words.kmpSearch("abc", "ab"))
    }

    @Test fun testLcs() {
        assertEquals(4, Words.lcs("AGGTAB", "GXTXAYB"))
        assertEquals(3, Words.lcs("ABC", "ABC"))
        assertEquals(0, Words.lcs("ABC", "DEF"))
        assertEquals(0, Words.lcs("", "ABC"))
        assertEquals(0, Words.lcs("ABC", ""))
    }
}