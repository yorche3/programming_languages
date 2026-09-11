module Test.Main where

import Prelude

import Effect (Effect)
import Effect.Class.Console (log)

import Test.NumbersIterativeTest as IterativeTest
import Test.NumbersRecursiveTest as RecursiveTest

main :: Effect Unit
main = do
  log "🍝"
  RecursiveTest.main
  IterativeTest.main
