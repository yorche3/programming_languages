int fibonacci(int n) {
    return fibonacci_iter(n, 0, 1);
}

int fibonacci_iter(int n, int acc2, int acc1) {
    if(n <= 1) return n;
    if(n == 2) return acc1 + acc2;
    return fibonacci_iter(n - 1, acc1, acc1 + acc2);
}

int factorial(int n) {
    return factorial_iter(n, 1);
}

int factorial_iter(int n, int acc) {
    if(n <= 1) return acc;
    return factorial_iter(n - 1, n * acc);
}

int sum_numbers(int n) {
    return sum_numbers_iter(n, 0);
}

int sum_numbers_iter(int n, int acc) {
    if(n <= 0) return acc;
    return sum_numbers_iter(n - 1, n + acc);
}