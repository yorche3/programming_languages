namespace test

open NUnit.Framework
open src.NumbersRecursive

[<TestFixture>]
module RecursiveTests =

    [<Test>]
    let ``Test Fibonacci recursive`` () =
        Assert.AreEqual(5, fibonacci 5)

    [<Test>]
    let ``Test Factorial recursive`` () =
        Assert.AreEqual(120, factorial 5)

    [<Test>]
    let ``Test sum_numbers recursive`` () =
        Assert.AreEqual(15, sum_numbers 5)