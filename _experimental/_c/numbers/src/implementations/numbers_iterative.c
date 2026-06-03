#include "../interfaces/numbers_iterative.h"

int fibonacci(int n) {
    return fibonacci_iter(n, 0, 1);
}

int factorial(int n) {
    return factorial_iter(n-1, n);
}

int sum_numbers(int n) {
    return sum_numbers_iter(n, 0);
}

int fibonacci_iter(int n, int acc2, int acc1) {
    if (n <= 1) {
        return n;
    } else if (n == 2) {
        return acc2 + acc1;
    } else {
        return fibonacci_iter(n - 1, acc1, acc1 + acc2);
    }
}

int factorial_iter(int n, int accumulator) {
    if (n == 1) {
        return accumulator;
    } else {
        return factorial_iter(n - 1, n * accumulator);
    }
}

int sum_numbers_iter(int n, int accumulator) {
    if (n == 0) {
        return accumulator;
    } else {
        return sum_numbers_iter(n - 1, n + accumulator);
    }
}