# Numbers

The integer data type is the simplest to manipulate without additional libraries, and related algorithms are among the most commonly used in education.

## Objectives

- Translate common algorithms to work with integer numbers.
    - Fibonacci
    - Factorial
    - Sum of first n numbers
- Create a suite of unit tests to validate the implementations.

## Goals

- Implenment two recursive solutions for each algorithm
- Structure the project with separate src and test directories
- Write unit tests for multiple classes/modules/namespaces.

## Structure

```text
numbers
├── src
│   ├── solution1.ext
│   └── solution2.ext
└── test
    └── test.ext
```

## Example Code

```pseudocode
container solution1
    .- fibonacci(n)
        if n <= 1
            return n
        return fibonacci(n - 1) + fibonacci(n - 2)

    .- factorial(n)
        if n == 0
            return 1
        return n * factorial(n - 1)

    .- sum_of_first_n(n)
        if n == 0
            return 0
        return n + sum_of_first_n(n - 1)
end container
```

```pseudocode
container solution2
    .- fibonacci(n)
        return fibonacci_iter(n, acc2, acc1)
    .- fibonacci_iter(n, acc2, acc1)
        if n <= 0
            return acc2
        if n <= 2
            return acc1 + acc2
        return fibonacci_iter(n - 1, acc1, acc1 + acc2)

    .- factorial(n)
        return factorial_iter(n, acc)
    .- factorial_iter(n, acc)
        if n <= 1
            return acc
        return fibonacci(n - 1, n * acc)
    
    .- sum_numbers(n)
        return sum_numbers_iter(n, acc)
    .- sum_numbers_iter(n, acc)
        if n <= 0
            return  acc
        return sum_numbers_iter(n - 1, n + acc)
```
***Solution 2 is the iterative version converted into a recursive form, using auxiliary functions with accumulators to maintain state.