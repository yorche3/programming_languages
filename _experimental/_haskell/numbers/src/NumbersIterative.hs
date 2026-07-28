module NumbersIterative (fibonacci, factorial, sumNumbers) where

fibonacci :: Int -> Int
fibonacci n = fib_iter n 0 1
  where
    fib_iter n acc2 acc1
        | n <= 0    = acc2
        | n <= 2    = acc1 + acc2
        | otherwise = fib_iter (n - 1) acc1 (acc1 + acc2)

factorial :: Int -> Int
factorial n = factorial_iter n 1
  where
    factorial_iter n acc
        | n <= 1    = acc
        | otherwise = factorial_iter (n - 1) (n * acc)

sumNumbers :: Int -> Int
sumNumbers n = sum_iter n 0
  where
    sum_iter n acc
        | n <= 0    = acc
        | otherwise = sum_iter (n - 1) (n + acc)