#include "../interfaces/numbers_iterative.h"

int NumbersIterative::fibonacci(int n)
{
    return fibonacci_iter(n, 0, 1);
}

int NumbersIterative::fibonacci_iter(int n, int acc2, int acc1)
{
    if (n <= 1)
    {
        return n;
    }
    else if(n == 2)
    {
        return acc1 +acc2;
    }
    else
    {
        return fibonacci_iter(n - 1, acc1, acc1 + acc2);
    }
}

int NumbersIterative::factorial(int n)
{
    return factorial_iter(n, 1);
}

int NumbersIterative::factorial_iter(int n, int accumulator)
{
    if(n <= 1)
    {
        return accumulator;
    }
    return factorial_iter(n - 1, n * accumulator);
}

int NumbersIterative::sum_numbers(int n)
{
    return sum_numbers_iter(n, 0);
}

int NumbersIterative::sum_numbers_iter(int n, int accumulator)
{
    if(n <= 0){
        return accumulator;
    }
    return sum_numbers_iter(n - 1, n + accumulator);
}