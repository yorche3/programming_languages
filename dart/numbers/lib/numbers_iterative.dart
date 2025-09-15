class NumbersIterative {
  int fibonacci(int n) {
    return fibonacciIter(n, 0, 1);
  }

  int fibonacciIter(int n, int acc2, int acc1) {
    if (n <= 1) {
      return n;
    } else if (n == 2) {
      return acc2 + acc1;
    } else {
      return fibonacciIter(n - 1, acc1, acc1 + acc2);
    }
  }

  int factorial(int n) {
    return factorialIter(n - 1, n);
  }

  int factorialIter(int n, int accumulator) {
    if (n <= 1) {
      return accumulator;
    }
    return factorialIter(n - 1, n * accumulator);
  }

  int sumNumbers(int n) {
    return sumNumbersIter(n - 1, n);
  }

  int sumNumbersIter(int n, int accumulator) {
    if (n <= 0) {
      return accumulator;
    }
    return sumNumbersIter(n - 1, n + accumulator);
  }
}
