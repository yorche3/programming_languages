#include "../include/numerical.h"

int fibonacci (int n)
{
    if (n < 0)
    {
        return -1;
    } else if (n < 2)
    {
        return n;
    }
    int acc2 = 0;
    int acc1 = 1;
    int aux = 0;
    while (n > 2)
    {
        aux = acc1 + acc2;
        acc2 = acc1;
        acc1 = aux;
        n--;
    }
    return acc1 + acc2;
}

int factorial (int n)
{
    if (n < 0)
    {
        return -1;
    }
    int acc = 1;
    while (n > 1)
    {
        acc = n * acc;
        n--;
    }
    return acc;
}

int gcd (int a, int b)
{
    int aux = 0;
    while (b != 0)
    {
        aux = a % b;
        a = b;
        b = aux;
    }
    return a;
}

int lcm (int a, int b)
{
    return (a / gcd(a, b)) * b;
}