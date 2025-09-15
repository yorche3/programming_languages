pub fn fibonacci(n: u32) u32 {
    if (n == 0) {
        return 0;
    } else if (n == 1) {
        return 1;
    } else {
        return fibonacci(n - 1) + fibonacci(n - 2);
    }
}

pub fn factorial(n: u32) u32 {
    if (n <= 1) {
        return 1;
    } else {
        return n * factorial(n - 1);
    }
}

pub fn sum_numbers(n: u32) u32 {
    if (n <= 0) {
        return 0;
    } else {
        return n + sum_numbers(n - 1);
    }
}
