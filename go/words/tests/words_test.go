package tests

import (
	"testing"

	. "example.com/words/words"
)

func TestReverseString(t *testing.T) {
	cases := []struct {
		s        string
		expected string
	}{
		{"hello", "olleh"},
		{"a", "a"},
		{"", ""},
	}
	for _, c := range cases {
		result := ReverseString(c.s)
		if result != c.expected {
			t.Errorf("ReverseString(%s) = %s; want %s", c.s, result, c.expected)
		}
	}
}

func TestIsPalindrome(t *testing.T) {
	cases := []struct {
		s        string
		expected bool
	}{
		{"race car", true},
		{"level", true},
		{"hello", false},
		{"a", true},
		{"", true},
	}
	for _, c := range cases {
		result := IsPalindrome(c.s)
		if result != c.expected {
			t.Errorf("IsPalindrome(%s) = %t; want %t", c.s, result, c.expected)
		}
	}
}

func TestKMPSearch(t *testing.T) {
	cases := []struct {
		sub      string
		string   string
		expected bool
	}{
		{"test", "this is a test", true},
		{"not", "this is a test", false},
		{"", "any string", true},
		{"abc", "abc", true},
		{"abc", "ab", false},
	}
	for _, c := range cases {
		result := KMPSearch(c.sub, c.string)
		if result != c.expected {
			t.Errorf("KMPSearch(%s, %s) = %t; want %t", c.sub, c.string, result, c.expected)
		}
	}
}

func TestLCS(t *testing.T) {
	cases := []struct {
		str1     string
		str2     string
		expected int
	}{
		{"AGGTAB", "GXTXAYB", 4},
		{"ABC", "ABC", 3},
		{"ABC", "DEF", 0},
		{"", "ABC", 0},
		{"ABC", "", 0},
	}
	for _, c := range cases {
		result := LCS(c.str1, c.str2)
		if result != c.expected {
			t.Errorf("LCS(%s, %s) = %d; want %d", c.str1, c.str2, result, c.expected)
		}
	}
}
