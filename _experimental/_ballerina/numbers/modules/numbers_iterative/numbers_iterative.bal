public function fibonacci(int n) returns int {
    return fibonacciIter(n, 0, 1);
}

public function fibonacciIter(int n, int acc2, int acc1) returns int {
    if n <= 0 {
        return acc2;
    } else if n <= 2 {
        return acc1 + acc2;
    }
    return fibonacciIter(n - 1, acc1, acc1 + acc2);
}

public function factorial(int n) returns int {
    return factorialIter(n, 1);
}

public function factorialIter(int n, int acc) returns int {
    if n <= 1 {
        return acc;
    }
    return factorialIter(n - 1, n * acc);
}

public function sumNumbers(int n) returns int {
    return sumNumbersIter(n, 0);
}

public function sumNumbersIter(int n, int acc) returns int {
    if n <= 0 {
        return acc;
    }
    return sumNumbersIter(n - 1, n + acc);
}
