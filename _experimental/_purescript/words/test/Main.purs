module Test.Main where

import Prelude

import Effect (Effect)
import Effect.Class.Console (log)

import Test.NumericalTest as NumericalSuite
import Test.WordsTest as WordsSuite

main :: Effect Unit
main = do
  log "🍝"
  NumericalSuite.main
  WordsSuite.main

