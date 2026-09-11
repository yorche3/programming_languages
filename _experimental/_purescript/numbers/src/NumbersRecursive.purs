module NumbersRecursive where

import Prelude

fibonacci :: Int -> Int
fibonacci n = case n of
  0 -> 0
  1 -> 1
  _ -> fibonacci (n - 1) + fibonacci (n - 2)

factorial :: Int -> Int
factorial n = case n of
  0 -> 1
  _ -> n * factorial (n - 1)

sumNumbers :: Int -> Int
sumNumbers n = case n of
  0 -> 0
  _ -> n + sumNumbers (n - 1)