#include "../interfaces/numbers_recursive.h"

int NumbersRecursive::fibonacci(int n)
{
    if (n <= 1)
    {
        return n;
    }
    return fibonacci(n - 1) + fibonacci(n - 2);
}

int NumbersRecursive::factorial(int n)
{
    if (n <= 1)
    {
        return 1;
    }
    return n * factorial(n - 1);
}

int NumbersRecursive::sum_numbers(int n)
{
    if(n <= 0){
        return 0;
    }
    return n + sum_numbers(n - 1);
}