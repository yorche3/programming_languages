package tests

import (
	"testing"

	. "example.com/numbers/numbers_iterative"
)

func TestFibonacciIter(t *testing.T) {
	result := Fibonacci(5)
	expected := 5
	if result != expected {
		t.Errorf("Fibonacci(5) = %d; want %d", result, expected)
	} else {
		t.Log("Fibonacci... [OK]")
	}
}

func TestFactorialIter(t *testing.T) {
	result := Factorial(5)
	expected := 120
	if result != expected {
		t.Errorf("Factorial(5) = %d; want %d", result, expected)
	} else {
		t.Log("Factorial... [OK]")
	}
}

func TestSumNumbersIter(t *testing.T) {
	result := SumNumbers(5)
	expected := 15
	if result != expected {
		t.Errorf("SumNumbers(5) = %d; want %d", result, expected)
	} else {
		t.Log("SumNumbers... [OK]")
	}
}
