package tests

import (
	"testing"

	. "example.com/words/numerical"
)

func TestFibonacci(t *testing.T) {
	cases := []struct {
		n        int
		expected int
	}{
		{-3, -1},
		{10, 55},
		{15, 610},
	}
	for _, c := range cases {
		result := Fibonacci(c.n)
		if result != c.expected {
			t.Errorf("Fibonacci(%d) = %d; want %d", c.n, result, c.expected)
		}
	}
}

func TestFactorial(t *testing.T) {
	cases := []struct {
		n        int
		expected int
	}{
		{-3, -1},
		{5, 120},
		{10, 3628800},
	}
	for _, c := range cases {
		result := Factorial(c.n)
		if result != c.expected {
			t.Errorf("Factorial(%d) = %d; want %d", c.n, result, c.expected)
		}
	}
}

func TestGCD(t *testing.T) {
	cases := []struct {
		a        int
		b        int
		expected int
	}{
		{48, 18, 6},
		{100, 25, 25},
		{17, 13, 1},
	}
	for _, c := range cases {
		result := GCD(c.a, c.b)
		if result != c.expected {
			t.Errorf("GCD(%d, %d) = %d; want %d", c.a, c.b, result, c.expected)
		}
	}
}

func TestLCM(t *testing.T) {
	cases := []struct {
		a        int
		b        int
		expected int
	}{
		{4, 6, 12},
		{21, 6, 42},
		{7, 3, 21},
	}
	for _, c := range cases {
		result := LCM(c.a, c.b)
		if result != c.expected {
			t.Errorf("LCM(%d, %d) = %d; want %d", c.a, c.b, result, c.expected)
		}
	}
}
