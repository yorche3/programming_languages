pub fn fibonacci(n: u32) u32 {
    return fibonacci_iter(n, 0, 1);
}

fn fibonacci_iter(n: u32, acc2: u32, acc1: u32) u32 {
    if (n <= 1) {
        return n;
    } else if (n == 2) {
        return acc1 + acc2;
    } else {
        return fibonacci_iter(n - 1, acc1, acc1 + acc2);
    }
}

pub fn factorial(n: u32) u32 {
    return factorial_iter(n, 1);
}

fn factorial_iter(n: u32, acc: u32) u32 {
    if (n == 1) {
        return acc;
    } else {
        return factorial_iter(n - 1, n * acc);
    }
}

pub fn sum_numbers(n: u32) u32 {
    return sum_numbers_iter(n, 0);
}

fn sum_numbers_iter(n: u32, acc: u32) u32 {
    if (n == 0) {
        return acc;
    } else {
        return sum_numbers_iter(n - 1, n + acc);
    }
}
