import Test.Hspec
import qualified NumbersRecursiveSpec
import qualified NumbersIterativeSpec

main :: IO ()
main = hspec $ do
  describe "Recursive functions" NumbersRecursiveSpec.spec
  describe "Iterative functions" NumbersIterativeSpec.spec