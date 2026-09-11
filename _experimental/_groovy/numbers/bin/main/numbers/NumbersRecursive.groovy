class NumbersRecursive {
    NumbersRecursive() {}

    int fibonacci(int n) {
        if (n <= 0) {
            return 0
        } else if (n == 1) {
            return 1
        }
        return fibonacci(n - 1) + fibonacci(n - 2)
    }

    int factorial(int n) {
        if (n <= 1) {
            return 1
        }
        return n * factorial(n - 1)
    }

    int sumNumbers(int n) {
        if (n <= 0) {
            return 0
        }
        return n + sumNumbers(n - 1)
    }
}