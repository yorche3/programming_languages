import 'package:words/words.dart';
import 'package:test/test.dart';

void main() {
  group("Words", (){
    test('Reverse String', () {
      expect(Words.reverseString('hello'), equals('olleh'));
      expect(Words.reverseString('a'), equals('a'));
      expect(Words.reverseString(''), equals(''));
    });

    test('Is Palindrome', () {
      expect(Words.isPalindrome('race car'), equals(true));
      expect(Words.isPalindrome('level'), equals(true));
      expect(Words.isPalindrome('hello'), equals(false));
      expect(Words.isPalindrome('a'), equals(true));
      expect(Words.isPalindrome(''), equals(true));
    });

    test('Is Substring', () {
      expect(Words.kmpSearch('test', 'this is a test'), equals(true));
      expect(Words.kmpSearch('not', 'this is a test'), equals(false));
      expect(Words.kmpSearch('', 'any string'), equals(true));
      expect(Words.kmpSearch('abc', 'abc'), equals(true));
      expect(Words.kmpSearch('abc', 'ab'), equals(false));
    });

    test('Largest Common Subsequence', () {
      expect(Words.lcs('AGGTAB', 'GXTXAYB'), equals(4));
      expect(Words.lcs('ABC', 'ABC'), equals(3));
      expect(Words.lcs('ABC', 'DEF'), equals(0));
      expect(Words.lcs('', 'ABC'), equals(0));
      expect(Words.lcs('ABC', ''), equals(0));
    });
  });
}
