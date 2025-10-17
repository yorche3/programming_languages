namespace NumbersIterative;

public class Class1
{
    private int FibonacciIter (int n, int acc2, int acc1)
    {
        if (n <= 0)
        {
            return 0;
        }
        else if (n <= 2)
        {
            return acc1 + acc2;
        }
        return FibonacciIter(n - 1, acc1, acc1 + acc2);
    }

    public int Fibonacci(int n)
    {
        return FibonacciIter(n, 0, 1);
    }

    private long FactorialIter (int n, long acc)
    {
        if (n <= 1)
        {
            return acc;
        }
        return FactorialIter(n - 1, n * acc);
    }

    public long Factorial (int n)
    {
        return FactorialIter(n, 1);
    }

    private int SumNumbersIter (int n, int acc)
    {
        if (n <= 0)
        {
            return acc;
        }
        return SumNumbersIter(n - 1, n + acc);
    }

    public int SumNumbers (int n)
    {
        return SumNumbersIter(n, 0);
    }
}
