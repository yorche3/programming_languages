#include "../include/numerical.h"

// Implementation of the methods
int Numerical::fibonacci(int n) {
    if (n < 0) return -1;
    else if (n < 2) return n;
    int acc2 = 0, acc1 = 1, aux = 0;
    while(n-- > 2) {
        aux = acc1 + acc2;
        acc2 = acc1;
        acc1 = aux;
    }
    
    return acc1 + acc2;
}

long Numerical::factorial(int n) {
    if (n < 0) return -1;
    long acc = 1;
    while(n > 1) {
        acc *= n--;
    }
    
    return acc;
}

int Numerical::gcd(int a, int b) {
    int aux = 0;
    while(b != 0) {
        aux = a % b;
        a = b;
        b = aux;
    }
    return a;
}

int Numerical::lcm(int a, int b) {
    if (a == 0 || b == 0) return 0;
    return (a / gcd(a, b)) * b;
}