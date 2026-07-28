module NumbersRecursive (fibonacci, factorial, sumNumbers) where

fibonacci :: Int -> Int
fibonacci 0 = 0
fibonacci 1 = 1
fibonacci n = fibonacci (n - 1) + fibonacci (n - 2)

factorial :: Int -> Int
factorial 0 = 1
factorial n = n * factorial (n - 1)

sumNumbers :: Int -> Int
sumNumbers 0 = 0
sumNumbers n = n + sumNumbers (n - 1)