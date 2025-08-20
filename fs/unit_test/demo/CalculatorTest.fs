module CalculatorTest

open NUnit.Framework
open FsUnit
open Calculator

[<TestFixture>]
type CalculatorTests() =
    
    [<Test>]
    member this.TestAdd() =
        (add 2 3) |> should equal 5
    
    [<Test>]
    member this.TestSubtract() =
        (subtract 10 5) |> should equal 5