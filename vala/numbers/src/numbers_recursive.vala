namespace NumbersRecursiveNS {
  public class NumbersRecursive {
    public static int fibonacci(int n) {
      if(n <= 1) return n;
      return fibonacci(n - 1) + fibonacci(n - 2);
    }

    public static int factorial(int n) {
      if(n <= 1) return 1;
      return n * factorial(n - 1);
    }

    public static int sumNumbers(int n) {
      if(n <= 0) return 0;
      return n + sumNumbers(n - 1);
    }
  }
}