@module("..src/numbers_iterative") // Note: adjust path as needed
external fibonacci: (int) => int = "fibonacci";
external factorial: (int) => int = "factorial";
external sum_numbers: (int) => int = "sum_numbers";

open Jest
open Expect

test("testFibonacci", () =>
    expectfibonacci(5)) -> toBe(5))

test("testFactorial", () =>
    expect(factorial(5)) -> toBe(120))

test("testSumNumbers", () =>
    expect(sum_numbers(5)) -> toBe(15))