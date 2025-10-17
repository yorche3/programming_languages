namespace test.NumericalTests

open NUnit.Framework
open lib.Numerical

[<TestFixture>]
module NumericalTests =

    [<Test>]
    let ``Fibonacci`` () =
        Assert.AreEqual(-1, Numerical.fibonacci -3)
        Assert.AreEqual(55, Numerical.fibonacci 10)
        Assert.AreEqual(610, Numerical.fibonacci 15)

    [<Test>]
    let ``Factorial`` () =
        Assert.AreEqual(-1, Numerical.factorial -3)
        Assert.AreEqual(120, Numerical.factorial 5)
        Assert.AreEqual(3628800, Numerical.factorial 10)

    [<Test>]
    let ``Greatest Common Divisor`` () =
        Assert.AreEqual(6, Numerical.gcd 48 18)
        Assert.AreEqual(25, Numerical.gcd 100 25)
        Assert.AreEqual(1, Numerical.gcd 17 13)

    [<Test>]
    let ``Lowest Common Multiple`` () =
        Assert.AreEqual(12, Numerical.lcm 4 6)
        Assert.AreEqual(42, Numerical.lcm 21 6)
        Assert.AreEqual(21, Numerical.lcm 7 3)