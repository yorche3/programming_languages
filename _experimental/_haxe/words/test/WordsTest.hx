package test;

import haxe.unit.TestCase;
import haxe.unit.TestStatus;
import Words;

class WordsTest extends TestCase {

  public function new() {
    super();
  }

  public function testReverseString() {
    var cases = [
      { input: 'hello', expected: 'olleh' },
      { input: 'a', expected: 'a' },
      { input: '', expected: '' }
    ];

    for (c in cases) {
      assertEquals(c.expected, Words.reverseString(c.input));
    }
  }

  public function testIsPalindrome() {
    var cases = [
      { input: 'race car', expected: true },
      { input: 'level', expected: true },
      { input: 'hello', expected: false },
      { input: 'a', expected: true },
      { input: '', expected: true }
    ];

    for (c in cases) {
      assertEquals(c.expected, Words.isPalindrome(c.input));
    }
  }

  public function testIsSubstring() {
    var cases = [
      { sub: 'test', str: 'this is a test', expected: true },
      { sub: 'not', str: 'this is a test', expected: false },
      { sub: '', str: 'any string', expected: true },
      { sub: 'abc', str: 'abc', expected: true },
      { sub: 'abc', str: 'ab', expected: false }
    ];

    for (c in cases) {
      assertEquals(c.expected, Words.kmpSearch(c.sub, c.str));
    }
  }

  public function testLCS() {
    var cases = [
      { str1: 'AGGTAB', str2: 'GXTXAYB', expected: 4 },
      { str1: 'ABC', str2: 'ABC', expected: 3 },
      { str1: 'ABC', str2: 'DEF', expected: 0 },
      { str1: '', str2: 'ABC', expected: 0 },
      { str1: 'ABC', str2: '', expected: 0 }
    ];

    for (c in cases) {
      assertEquals(c.expected, Words.lcs(c.str1, c.str2));
    }
  }
}