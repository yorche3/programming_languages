#ifndef NUMBERS_ITERATIVE_H
#define NUMBERS_ITERATIVE_H

class NumbersIterative {
public:
    int fibonacci(int n);
    int factorial(int n);
    int sum_numbers(int n);
private:
    int fibonacci_iter(int n, int acc2, int acc1);
    int factorial_iter(int n, int accumulator);
    int sum_numbers_iter(int n, int accumulator);
};

#endif