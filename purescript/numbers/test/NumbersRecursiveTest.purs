module Test.NumbersRecursiveTest where

import Prelude

import Effect (Effect)
import Test.Unit (suite, test)
import Test.Unit.Main (runTest)
import Test.Unit.Assert as Assert
import NumbersRecursive (factorial, fibonacci, sumNumbers)

main :: Effect Unit
main = runTest do
  suite "Numbers Iterative Test" do
    test "fibonacci" do
      Assert.equal (fibonacci 5) 5
    test "factorial" do
      Assert.equal (factorial 5) 120
    test "sum of first n numbers" do
      Assert.equal (sumNumbers 5) 15