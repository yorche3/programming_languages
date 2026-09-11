namespace NumbersRecursiveTest;

using NumbersRecursive;

public class UnitTest1
{
    private readonly Class1 _numbers = new Class1();

    [Fact]
    public void TestFibonacci_WithNEquals5_Returns5()
    {
        int n = 5;
        int result = _numbers.Fibonacci(n);
        Assert.Equal(5, result);
    }

    [Fact]
    public void TestFactorial_WithNEquals5_Returns120()
    {
        int n = 5;
        long result = _numbers.Factorial(n);
        Assert.Equal(120, result);
    }

    [Fact]
    public void TestSumNumbers_WithNEquals5_Returns15()
    {
        int n = 5;
        int result = _numbers.SumNumbers(n);
        Assert.Equal(15, result);
    }
}