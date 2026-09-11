class NumbersIterative {
    NumbersIterative() {}

    int fibonacci(int n) {
        return fibonacciIter(n, 0, 1)
    }

    private int fibonacciIter(int n, int acc2, int acc1) {
        if (n <= 0) {
            return acc2
        } else if (n <= 1) {
            return acc1
        }
        return fibonacciIter(n - 1, acc1, acc1 + acc2)
    }

    int factorial(int n) {
        return factorialIter(n, 1)
    }

    private int factorialIter(int n, int acc) {
        if (n <= 0) {
            return acc
        }
        return factorialIter(n - 1, n * acc)
    }

    int sumNumbers(int n) {
        return sumNumbersIter(n, 0)
    }

    private int sumNumbersIter(int n, int acc) {
        if (n <= 0) {
            return acc
        }
        return sumNumbersIter(n - 1, n + acc)
    }
}