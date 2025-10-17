module NumericalTest where

import Test.HUnit
import Numerical (fibonacci, factorial, gcdy, lcmy)

testFibonacci :: Test
testFibonacci = TestList
  [ "fibonacci of -3" ~: (-1) ~=? fibonacci (-3)
  , "fibonacci of 10" ~: 55 ~=? fibonacci 10
  , "fibonacci of 15" ~: 610 ~=? fibonacci 15
  ]

testFactorial :: Test
testFactorial = TestList
  [ "factorial of -3" ~: (-1) ~=? factorial (-3)
  , "factorial of 5" ~: 120 ~=? factorial 5
  , "factorial of 10" ~: 3628800 ~=? factorial 10
  ]

testGcd :: Test
testGcd = TestList
  [ "gcd of 48 and 18" ~: 6 ~=? gcdy 48 18
  , "gcd of 100 and 25" ~: 25 ~=? gcdy 100 25
  , "gcd of 17 and 13" ~: 1 ~=? gcdy 17 13
  ]
testLcm :: Test
testLcm = TestList
  [ "lcm of 4 and 6" ~: 12 ~=? lcmy 4 6
  , "lcm of 21 and 6" ~: 42 ~=? lcmy 21 6
  , "lcm of 7 and 3" ~: 21 ~=? lcmy 7 3
  ]

tests :: Test
tests = TestList [
  TestLabel "Fibonacci Tests" testFibonacci,
  TestLabel "Factorial Tests" testFactorial,
  TestLabel "GCD Tests" testGcd,
  TestLabel "LCM Tests" testLcm
  ]