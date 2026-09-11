pub fn fibonacci(n: i32) i32 {
    if (n < 0) {
        return -1;
    } else if (n < 2) {
        return n;
    }
    return fibonacci_calc(n, 0, 1);
}

fn fibonacci_calc(n: i32, acc2: i32, acc1: i32) i32 {
    if (n == 2) {
        return acc1 + acc2;
    }
    return fibonacci_calc(n - 1, acc1, acc1 + acc2);
}

pub fn factorial(n: i32) i32 {
    if (n < 0) {
        return -1;
    }
    return factorial_calc(n, 1);
}

fn factorial_calc(n: i32, acc: i32) i32 {
    if (n <= 1) {
        return acc;
    }
    return factorial_calc(n - 1, n * acc);
}

pub fn gcd(a: i32, b: i32) i32 {
    if (b == 0) {
        return a;
    }
    return gcd(b, @mod(a, b));
}

pub fn lcm(a: i32, b: i32) i32 {
    return @divExact(a, gcd(a, b)) * b;
}
