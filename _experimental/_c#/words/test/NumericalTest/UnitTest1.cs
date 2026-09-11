namespace NumericalTest;

using Numerical;

public class UnitTest1
{
    private readonly Class1 _numbers = new Class1();

    [Fact]
    public void TestFibonacci()
    {
        int n = -3;
        int result = _numbers.Fibonacci(n);
        Assert.Equal(-1, result);
        n = 10;
        result = _numbers.Fibonacci(n);
        Assert.Equal(55, result);
        n = 15;
        result = _numbers.Fibonacci(n);
        Assert.Equal(610, result);
    }

    [Fact]
    public void TestFactorial()
    {
        int n = -3;
        long result = _numbers.Factorial(n);
        Assert.Equal(-1, result);
        n = 5;
        result = _numbers.Factorial(n);
        Assert.Equal(120, result);
        n = 10;
        result = _numbers.Factorial(n);
        Assert.Equal(3628800, result);
    }

    [Fact]
    public void TestGCD()
    {
        Assert.Equal(6, _numbers.GCD(48, 18));
        Assert.Equal(25, _numbers.GCD(100, 25));
        Assert.Equal(1, _numbers.GCD(17, 13));
    }

    [Fact]
    public void TestLCM()
    {
        Assert.Equal(12, _numbers.LCM(4, 6));
        Assert.Equal(42, _numbers.LCM(21, 6));
        Assert.Equal(21, _numbers.LCM(7, 3));
    }
}