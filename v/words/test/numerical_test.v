import numerical

fn test_fibonacci() {
  assert numerical.fibonacci(-3) == -1
  assert numerical.fibonacci(10) == 55
  assert numerical.fibonacci(15) == 610
}

fn test_factorial() {
	assert numerical.factorial(-3) == -1
  assert numerical.factorial(5) == 120
	assert numerical.factorial(10) == 3628800
}

fn test_gcd() {
	assert numerical.gcd(48, 18) == 6
	assert numerical.gcd(100, 25) == 25
	assert numerical.gcd(17, 13) == 1
}

fn test_lcm() {
	assert numerical.lcm(4, 6) == 12
	assert numerical.lcm(21, 6) == 42
	assert numerical.lcm(7, 3) == 21
}