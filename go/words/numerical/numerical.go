package numerical

func Fibonacci(n int) int {
	if n < 0 {
		return -1
	} else if n < 2 {
		return n
	}
	acc2 := 0
	acc1 := 1
	for n > 2 {
		acc2, acc1 = acc1, acc1+acc2
		n--
	}
	return acc1 + acc2
}

func Factorial(n int) int {
	if n < 0 {
		return -1
	}
	acc := 1
	for n > 1 {
		acc *= n
		n--
	}
	return acc
}

func GCD(a, b int) int {
	for b != 0 {
		a, b = b, a%b
	}
	return a
}

func LCM(a, b int) int {
	return (a / GCD(a, b)) * b
}
