#!/usr/bin/julia

module NumbersRecursive
export fibonacci, factorial_rec, sum_numbers

fibonacci(n::Int) :: Int = n <= 1 ? n : fibonacci(n - 1) + fibonacci(n - 2)
factorial_rec(n::Int) :: Int = n == 0 ? 1 : n * factorial_rec(n - 1)
sum_numbers(n::Int) :: Int = n == 0 ? 0 : n + sum_numbers(n - 1)
end