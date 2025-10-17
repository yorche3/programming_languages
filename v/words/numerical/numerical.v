module numerical

pub fn fibonacci(n int) int {
	if n < 0 {
		return -1
	} else if n < 2 {
		return n
	}
	mut acc1 := 1
	mut acc2 := 0
	mut aux := 0
	mut i := n
	for i > 2 {
		aux = acc1 + acc2
		acc2 = acc1
		acc1 = aux
		i -= 1
	}
	return acc1 + acc2
}

pub fn factorial(n int) int {
	if n < 0 {
		return -1
	}
	mut acc := 1
	mut i := n
	for i > 1 {
		acc *= i
		i -= 1
	}
	return acc
}

pub fn gcd(a int, b int) int {
	mut a_copy := a
	mut b_copy := b
	mut aux := 0
	for b_copy != 0 {
		aux = a_copy % b_copy
		a_copy = b_copy
		b_copy = aux
	}
	return a_copy
}

pub fn lcm(a int, b int) int {
	return (a / gcd(a, b)) * b
}