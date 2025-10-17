module Numerical (fibonacci, factorial, gcdy, lcmy) where

fibonacci :: Int -> Int
fibonacci n = fibonacciCalc n 0 1
  where
    fibonacciCalc :: Int -> Int -> Int -> Int
    fibonacciCalc x acc2 acc1
      | x < 0 = -1
      | x <= 1 = n
      | x == 2 = acc1 + acc2
      | otherwise = fibonacciCalc (x - 1) acc1 (acc1 + acc2)

factorial :: Int -> Int
factorial n = factorialCalc n 1
  where
    factorialCalc :: Int -> Int -> Int
    factorialCalc x acc
      | x < 0 = -1
      | x <= 1 = acc
      | otherwise = factorialCalc (x - 1) (x * acc)

gcdy :: Int -> Int -> Int
gcdy a b =
  if b == 0 then
    a
  else
    gcdy b (mod a b)

lcmy :: Int -> Int -> Int
lcmy a b = (a `div` gcdy a b) * b