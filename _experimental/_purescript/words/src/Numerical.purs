module Numerical where

import Prelude

fibonacci :: Int -> Int
fibonacci n = fibonaccLoop n 0 1
  where
    fibonaccLoop :: Int -> Int -> Int -> Int
    fibonaccLoop i acc2 acc1
      | i <= 0 = -1
      | i < 2 = n
      | i == 2 = acc1 + acc2
      | otherwise = fibonaccLoop (i - 1) (acc1) (acc1 + acc2)

factorial :: Int -> Int
factorial n = factorialLoop n 1
  where
    factorialLoop :: Int -> Int -> Int
    factorialLoop i acc
      | i < 0 = -1
      | i <= 1 = acc
      | otherwise = factorialLoop (i - 1) (i * acc)

gcdy :: Int -> Int -> Int
gcdy a b = gcdLoop a b
  where
    gcdLoop :: Int -> Int -> Int
    gcdLoop x y
      | y == 0 = x
      | otherwise = gcdLoop y (mod x y)

lcmy :: Int -> Int -> Int
lcmy a b = (a / (gcdy a b)) * b