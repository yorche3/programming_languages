class Numerical {}

object Numerical {
	def fibonacci(n: Int): Int = {
		if (n < 0) return -1
		if (n < 2) return n
		var acc1 = 1
		var acc2 = 0
		for (_ <- 3 to n) {
			val temp = acc1
			acc1 = acc1 + acc2
			acc2 = temp
		}
		acc1 + acc2
	}

	def factorial(n: Int): Int = {
		if (n < 0) return -1
		if (n == 0 || n == 1) return 1
		var acc = 1
		for (i <- 2 to n) {
			acc *= i
		}
		acc
	}

	def gcd(a: Int, b: Int): Int = {
		if (b == 0) return a.abs
		gcd(b, a % b)
	}

	def lcm(a: Int, b: Int): Int = {
		(a / gcd(a, b)) * b
	}
}