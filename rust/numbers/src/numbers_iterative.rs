pub fn fibonacci(n: i32) -> i32 {
    fn fibonacci_iter(n: i32, acc2: i32, acc1: i32) -> i32 {
        if n <= 0 {
            acc2
        } else if n == 1 {
            acc1
        } else {
            fibonacci_iter(n - 1, acc1, acc1 + acc2)
        }
    }
    fibonacci_iter(n, 0, 1)
}

pub fn factorial(n: u32) -> u32 {
    fn factorial_iter(n: u32, acc: u32) -> u32 {
        if n <= 1 {
            acc
        } else {
            factorial_iter(n - 1, n * acc)
        }
    }
    factorial_iter(n, 1)
}

pub fn sum_numbers(n: i32) -> i32 {
    fn sum_numbers_iter(n: i32, acc: i32) -> i32 {
        if n <= 0 {
            acc
        } else {
            sum_numbers_iter(n - 1, n + acc)
        }
    }
    sum_numbers_iter(n, 0)
}