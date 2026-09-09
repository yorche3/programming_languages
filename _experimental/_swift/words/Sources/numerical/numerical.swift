public struct Numerical {
	public static func fibonacci(n: Int) -> Int {
		if n < 0 { return -1 }
		if n <= 1 { return n }
		var acc1 = 1
		var acc2 = 0
		var aux = 0
		for _ in 2..<n {
			aux = acc1
			acc1 = acc1 + acc2
			acc2 = aux
		}
		return acc1 + acc2
	}

	public static func factorial(n: Int) -> Int {
		if n < 0 { return -1 }
		var acc = 1
		for i in 2..<(n + 1) {
			acc = acc * i
		}
		return acc
	}

	public static func gcd(a: Int, b: Int) -> Int {
		if b == 0 { return a }
		return gcd(a: b, b: a % b)
	}

	public static func lcm(a: Int, b: Int) -> Int {
		return (a / gcd(a: a, b: b)) * b
	}
}