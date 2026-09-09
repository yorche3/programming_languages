@module("..src/numbers_recursive") // Note: adjust path as needed
external fibonacci: (int) => int = "fibonacci";
external factorial: (int) => int = "factorial";
external sum_numbers: (int) => int = "sum_numbers";

open JestBindings

let assertEqual = (expected: int, actual: int) => {
  expect(actual)->toBe(expected)
}

let testFibonacci = () => {
  let result = fibonacci(5)
  Js.log2("Fib(5):", result)
  assertEqual(5, result)
}

let testFactorial = () => {
  let result = factorial(5)
  Js.log2("Factorial(5):", result)
  assertEqual(120, result)
}

let testSumNumbers = () => {
  let result = sum_numbers(5)
  Js.log2("Sum(5):", result)
  assertEqual(15, result)
}

testFibonacci()
testFactorial()
testSumNumbers()