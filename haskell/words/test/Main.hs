module Main (main) where

import Test.HUnit
import qualified System.Exit as Exit

-- Import your test modules
import qualified NumericalTest
import qualified WordsyTest

allTests :: Test
allTests = TestList
    [ "Numerical Suite" ~: NumericalTest.tests
    , "Wordsy Suite"    ~: WordsyTest.tests
    ]

main :: IO ()
main = do
    result <- runTestTT allTests
    if failures result > 0 then Exit.exitFailure else Exit.exitSuccess
