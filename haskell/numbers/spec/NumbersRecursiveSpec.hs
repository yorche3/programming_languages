module NumbersRecursiveSpec (spec) where

import Test.Hspec
import NumbersRecursive (fibonacci, factorial, sumNumbers)

spec :: Spec
spec = do
  describe "fibonacci" $ do
    it "calculates the nth Fibonacci number" $ do
      fibonacci 5 `shouldBe` 5
  
  describe "factorial" $ do
    it "calculates factorial of a number" $ do
      factorial 5 `shouldBe` 120

  describe "sumNumbers" $ do
    it "sums numbers from 1 to n" $ do
      sumNumbers 5 `shouldBe` 15