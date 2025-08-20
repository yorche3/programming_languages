import Test.Hspec
import Calculator (addition, subtraction)

main :: IO ()
main = hspec $ do
  describe "Calculator" $ do
    describe "add" $ do
      it "adds two positive numbers" $ do
        addition 2 3 `shouldBe` 5

    describe "subtract" $ do
      it "subtracts two positive numbers" $ do
        subtraction 5 3 `shouldBe` 2