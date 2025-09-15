#!/usr/bin/julia

module NumbersIterative
export fibonacci, factorial_rec, sum_numbers

fibonacci(n::Int) :: Int = fibonacci_iter(n, 0, 1)
fibonacci_iter(n::Int, acc2::Int, acc1::Int) :: Int = 
    if n <= 0 acc2
    elseif n <= 2 acc2 + acc1
    else fibonacci_iter(n - 1, acc1, acc2 + acc1)
    end
factorial_rec(n::Int) :: Int = factorial_iter(n, 1)
factorial_iter(n::Int, acc::Int) :: Int = n == 0 ?  acc : factorial_iter(n - 1, n * acc)
sum_numbers(n::Int) :: Int = sum_numbers_iter(n, 0)
sum_numbers_iter(n::Int, acc::Int) :: Int = n == 0 ? acc : sum_numbers_iter(n - 1, n + acc)
end