module numbers_iterative

pub fn fibonacci(n int) int {
    return fibonacci_iter(n, 0, 1)
}

fn fibonacci_iter(n int, acc2 int, acc1 int) int {
    if n <= 1 {
        return n
    }
    if n == 2 {
        return acc1 + acc2
    }
    return fibonacci_iter(n - 1, acc1, acc1 + acc2)
}

pub fn factorial(n int) int {
    return factorial_iter(n, 1)
}

fn factorial_iter(n int, acc int) int {
    if n == 1 {
        return acc
    }
    return factorial_iter(n - 1, n * acc)
}

pub fn sum_numbers(n int) int {
    return sum_numbers_iter(n, 0)
}

fn sum_numbers_iter(n int, acc int) int {
    if n == 0 {
        return acc
    }
    return sum_numbers_iter(n - 1, n + acc)
}