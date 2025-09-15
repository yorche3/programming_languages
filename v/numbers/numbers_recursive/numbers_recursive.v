module numbers_recursive

pub fn fibonacci(n int) int {
	if n <= 0 {
		return 0
	}
	if n == 1 {
		return 1
	}
	return fibonacci(n - 1) + fibonacci(n - 2)
}

pub fn factorial(n int) int {
	if n<= 1 {
		return 1
	}
	return n * factorial(n - 1)
}

pub fn sum_numbers(n int) int {
	if n<= 0 {
		return 0
	}
	return n + sum_numbers(n - 1)
}