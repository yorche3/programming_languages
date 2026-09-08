module NumbersIterative where

import Prelude
fibonacci :: Int -> Int
fibonacci n = fibonacciIter n 0 1

fibonacciIter :: Int -> Int -> Int -> Int
fibonacciIter n acc2 acc1 = case n of
  0 -> 0
  1 -> acc2
  _ -> if n == 2 then acc1 + acc2
       else fibonacciIter (n - 1) (acc1) (acc2 + acc1)

factorial :: Int -> Int
factorial n = factorialIter n 1

factorialIter :: Int -> Int -> Int
factorialIter n acc = case n of
  0 -> acc
  _ -> factorialIter (n - 1) (n * acc)

sumNumbers :: Int -> Int
sumNumbers n = sumNumbersIter n 0

sumNumbersIter :: Int -> Int -> Int
sumNumbersIter n acc = case n of
  0 -> acc
  _ -> sumNumbersIter (n - 1) (n + acc)