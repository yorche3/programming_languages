namespace NumbersRecursive;

public class Class1
{
    public int Fibonacci(int n)
    {
        if (n <= 1) return n;
        return Fibonacci(n - 1) + Fibonacci(n - 2);
    }

    public long Factorial(int n)
    {
        if (n <= 1) return 1;
        return n * Factorial(n - 1);
    }

    public int SumNumbers(int n)
    {
        if (n <= 0) return 0;
        return n + SumNumbers(n - 1);
    }
}
