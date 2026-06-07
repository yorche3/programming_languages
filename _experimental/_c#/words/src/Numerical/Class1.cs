namespace Numerical;

public class Class1
{
    public int Fibonacci (int n)
    {
        if (n < 0)
        {
            return -1;
        }
        else if (n <= 1)
        {
            return n;
        }
        int acc2 = 0;
        int acc1 = 1;
        int aux = 0;

        while (n > 2)
        {
            aux = acc1 + acc2;
            acc2 = acc1;
            acc1 = aux;
            n--;
        }

        return acc1 + acc2;
    }

    public long Factorial (int n)
    {
        if (n < 0)
        {
            return -1;
        }
        long acc = 1;
        while (n > 1)
        {
            acc *= n--;
        }

        return acc;
    }

    public int GCD (int a, int b)
    {
        while (b != 0)
        {
            (a, b) = (b, a % b);
        }

        return a;
    }

    public int LCM (int a, int b)
    {
        return (a / GCD(a, b)) * b;
    }
}
