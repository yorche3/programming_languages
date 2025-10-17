pub fn fibonacci(n: i32) -> i32 {
	if n < 0 {
		return -1;
	} else if n < 2 {
		return n;
	}
	let mut acc2 = 0;
	let mut acc1 = 1;
	for _ in 2..n {
		let temp = acc1;
		acc1 = acc1 + acc2;
		acc2 = temp;
	}
	return acc1 + acc2;
}

pub fn factorial(n: i32) -> i32 {
	if n < 0 {
		return -1;
	} else if n == 0 || n == 1 {
		return 1;
	}
	let mut acc = 1;
	for i in 2..=n {
		acc *= i;
	}
	return acc;
}

pub fn gcd(a: i32, b: i32) -> i32 {
	let mut x = a;
	let mut y = b;
	while y != 0 {
		let temp = y;
		y = x % y;
		x = temp;
	}
	return x;
}

pub fn lcm(a: i32, b: i32) -> i32 {
	return (a / gcd(a, b)) * b;
}