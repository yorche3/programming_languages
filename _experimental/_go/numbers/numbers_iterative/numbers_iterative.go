package numbers_recursive

func Fibonacci(n int) int {
	return FibonacciIter(n, 0, 1)
}

func FibonacciIter(n, acc2, acc1 int) int {
	if n <= 0 {
		return acc2
	} else if n == 1 {
		return acc1
	}
	return FibonacciIter(n-1, acc1, acc1+acc2)
}

func Factorial(n int) int {
	return FactorialIter(n, 1)
}

func FactorialIter(n, acc int) int {
	if n == 0 {
		return acc
	}
	return FactorialIter(n-1, n*acc)
}

func SumNumbers(n int) int {
	return SumNumbersIter(n, 0)
}

func SumNumbersIter(n, acc int) int {
	if n <= 0 {
		return acc
	}
	return SumNumbersIter(n-1, n+acc)
}
