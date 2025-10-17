module Test.NumericalTest where

import Prelude

import Effect (Effect)
import Test.Unit (suite, test)
import Test.Unit.Assert as Assert
import Test.Unit.Main (runTest)
import Numerical (factorial, fibonacci, gcdy, lcmy)

main :: Effect Unit
main = runTest do
  suite "Numbers Iterative Test" do
    test "fibonacci" do
      Assert.equal (-1) (fibonacci (-3))
      Assert.equal 55 (fibonacci 10)
      Assert.equal 610 (fibonacci 15)
    test "factorial" do
      Assert.equal (-1) (factorial (-3))
      Assert.equal 120 (factorial 5)
      Assert.equal 3628800 (factorial 10)
    test "greatest common divisor" do
      Assert.equal 6 (gcdy 48 18)
      Assert.equal 25 (gcdy 100 25)
      Assert.equal 1 (gcdy 17 13)
    test "lowest common multiple" do
      Assert.equal 12 (lcmy 4 6)
      Assert.equal 42 (lcmy 21 6)
      Assert.equal 21 (lcmy 7 3)