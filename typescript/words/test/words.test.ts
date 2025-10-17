import { reverse_string, is_palindrome, kmp_search, lcs } from '../src/words';

describe('Words Functions', () => {
  test('reverse_string', () => {
		expect(reverse_string('hello')).toBe('olleh');
		expect(reverse_string('a')).toBe('a');
		expect(reverse_string('')).toBe('');
	});
	test('is_palindrome', () => {
		expect(is_palindrome('racecar')).toBe(true);
		expect(is_palindrome('level')).toBe(true);
		expect(is_palindrome('hello')).toBe(false);
		expect(is_palindrome('a')).toBe(true);
		expect(is_palindrome('')).toBe(true);
	});
	test('is_substring', () => {
		expect(kmp_search('test', 'this is a test')).toBe(true);
		expect(kmp_search('not', 'this is a test')).toBe(false);
		expect(kmp_search('', 'any string')).toBe(true);
		expect(kmp_search('abc', 'abc')).toBe(true);
		expect(kmp_search('abc', 'ab')).toBe(false);
	});
	test('longest_common_subsequence', () => {
		expect(lcs('AGGTAB', 'GXTXAYB')).toBe(4);
		expect(lcs('ABC', 'ABC')).toBe(3);
		expect(lcs('ABC', 'DEF')).toBe(0);
		expect(lcs('', 'ABC')).toBe(0);
		expect(lcs('ABC', '')).toBe(0);
	});
});