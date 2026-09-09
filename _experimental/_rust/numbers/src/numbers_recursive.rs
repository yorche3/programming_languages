pub fn fibonacci(n: i32) -> i32 {
    if n <= 0 {
        0
    } else if n == 1 {
        1
    } else {
        fibonacci(n - 1) + fibonacci(n - 2)
    }
}

pub fn factorial(n: u32) -> u32 {
    if n <= 1 {
        1
    } else {
        n * factorial(n - 1)
    }
}

pub fn sum_numbers(n: i32) -> i32 {
    if n <= 0 {
        0
    } else {
        n + sum_numbers(n - 1)
    }
}
