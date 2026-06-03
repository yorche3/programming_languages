public function fibonacci(int n) returns int {
    if n <= 0 {
        return 0;
    } else if n == 1 {
        return 1;
    }
    return fibonacci(n - 1) + fibonacci(n - 2);
}

public function factorial(int n) returns int {
    if n <= 1 {
        return 1;
    }
    return n * factorial(n - 1);
}

public function sumNumbers(int n) returns int {
    if n <= 0 {
        return 0;
    }
    return n + sumNumbers(n - 1);
}
