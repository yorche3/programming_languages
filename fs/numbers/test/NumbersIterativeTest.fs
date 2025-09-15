namespace test

open NUnit.Framework
open src.NumbersIterative

[<TestFixture>]
module IterativeTests =

    [<Test>]
    let ``Test Fibonacci iterative`` () =
        Assert.AreEqual(5, fibonacci 5)

    [<Test>]
    let ``Test Factorial iterative`` () =
        Assert.AreEqual(120, factorial 5)

    [<Test>]
    let ``Test sum_numbers iterative`` () =
        Assert.AreEqual(15, sum_numbers 5)