object Numerical {
	fun fibonacci(n: Int): Int {
		if (n < 0) return -1
		if (n < 2) return n
		var acc1 = 1
		var acc2 = 0
		for (i in 3..n) {
			val temp = acc1
			acc1 = acc1 + acc2
			acc2 = temp
		}
		return acc1 + acc2
	}

	fun factorial(n: Int): Int {
		if (n < 0) return -1
		var acc = 1
		for (i in 2..n) {
			acc *= i
		}
		return acc
	}

	fun gcd(a: Int, b: Int): Int {
		if (b == 0) return a
		return gcd(b, a % b)
	}

	fun lcm(a: Int, b: Int): Int {
		return (a / gcd(a, b)) * b
	}
}