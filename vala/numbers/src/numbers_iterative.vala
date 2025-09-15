namespace NumbersIterativeNS {
  public class NumbersIterative {
    public static int fibonacci(int n) {
      return fibonacciIter(n, 0, 1);
    }

    private static int fibonacciIter(int n, int acc2, int acc1){
      if(n <= 1) return n;
      else if(n == 2) return acc1 + acc2;
      return fibonacciIter(n - 1, acc1, acc1 + acc2);
    }

    public static int factorial(int n){
      return factorialIter(n, 1);
    }

    private static int factorialIter(int n, int acc){
      if(n <= 1) return acc;
      return  factorialIter(n - 1, n * acc);
    }

    public static int sumNumbers(int n){
      return sumNumbersIter(n, 0);
    }

    private static int sumNumbersIter(int n, int acc){
      if(n <= 0) return acc;
      return sumNumbersIter(n - 1, n + acc);
    }
  }
}