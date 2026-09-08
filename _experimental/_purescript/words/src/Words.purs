module Words where

import Prelude
import Data.Either (Either(..))
import Data.Array (uncons, replicate, (!!), updateAt, intercalate)
import Data.Maybe (Maybe(Just, Nothing), fromMaybe)
import Data.String.CodeUnits (toCharArray, fromCharArray, charAt, length)
import Data.String.Regex (regex, replace)
import Data.String.Regex.Flags (noFlags)

reverseString :: String -> String
reverseString str = fromCharArray (reverseLoop (toCharArray str) [])
  where
    reverseLoop :: Array Char -> Array Char -> Array Char
    reverseLoop chArr acc = case uncons chArr of
      Just { head: x, tail: xs } -> reverseLoop xs ([x] <> acc)
      Nothing -> acc

replaceAll :: String -> String
replaceAll s = 
  case regex "\\s+" noFlags of
    Right r -> replace r "" s
    Left _ -> s

isPalindrome :: String -> Boolean
isPalindrome s =
  let
    cleanedStr = replaceAll s
    palindromeLoop :: Int -> Int -> Boolean
    palindromeLoop i j
      |i >= j = true
      |charAt i cleanedStr /= charAt j cleanedStr = false
      |otherwise = palindromeLoop (i + 1) (j - 1)
  in
    palindromeLoop 0 ((length cleanedStr) - 1)

getArrayInt :: Maybe (Array Int) -> Array Int
getArrayInt maybeArr = fromMaybe [] maybeArr

getInt :: Maybe Int -> Int
getInt maybeInt = fromMaybe 0 maybeInt

computeLPSArray :: String -> Array Int
computeLPSArray pat =
  let
    lenPat = length pat
    lpsBase = replicate lenPat 0
    lpsLoop :: Int -> Int -> Array Int -> Array Int
    lpsLoop i len lps
      | i >= lenPat = lps
      | charAt i pat == charAt len pat =
          lpsLoop (i + 1) (len + 1) (getArrayInt (updateAt i (len + 1) lps))
      | otherwise = if len > 0 
        then lpsLoop i (getInt (lps !! (len - 1))) lps
        else lpsLoop (i + 1) len lps
  in
    lpsLoop 1 0 lpsBase

kmpSearch :: String -> String -> Boolean
kmpSearch sub txt
  | sub == "" = true
  | length sub > length txt = false
  | otherwise =
    let
      lenSub = length sub
      lenTxt = length txt
      lps = computeLPSArray sub
      kmpLoop :: Int -> Int -> Boolean
      kmpLoop i j
        | j >= lenSub = true
        | i >= lenTxt = false
        | charAt i txt == charAt j sub = kmpLoop (i + 1) (j + 1)
        | otherwise = if j > 0
          then kmpLoop (i - (j - 1)) (getInt (lps !! (j - 1)))
          else kmpLoop (i + 1) j
    in
      kmpLoop 0 0

getMatrix :: Maybe (Array (Array Int)) -> Array (Array Int)
getMatrix maybeMatrix = fromMaybe [] maybeMatrix

getRow :: Array (Array Int) -> Int -> Array Int
getRow matrix i = getArrayInt (matrix !! i)

getCount :: Array (Array Int) -> Int -> Int -> Int
getCount matrix i j = getInt ((getArrayInt (matrix !! i)) !! j)

setCount :: Array (Array Int) -> Int -> Int -> Int -> Array (Array Int)
setCount matrix i j value = getMatrix (updateAt i (getArrayInt (updateAt j value (getRow matrix i))) matrix)

lcs :: String -> String -> Int
lcs str1 str2 =
  let
    len1 = length str1
    len2 = length str2
    dpBase = replicate (len1 + 1) (replicate (len2 + 1) 0)
    loopLCS :: Int -> Int -> Array (Array Int) -> Array (Array Int)
    loopLCS i j dpLoop
      | i > len1 = dpLoop
      | j > len2 = loopLCS (i + 1) 1 dpLoop
      | charAt (i - 1) str1 == charAt (j - 1) str2 =
        let
          newValue = (getCount dpLoop (i - 1) (j - 1)) + 1
          dpUpdated = setCount dpLoop i j newValue
        in
          loopLCS i (j + 1) dpUpdated
      | otherwise =
        let
          value1 = getCount dpLoop (i - 1) j
          value2 = getCount dpLoop i (j - 1)
          newValue = max value1 value2
          dpUpdated = setCount dpLoop i j newValue
        in
          loopLCS i (j + 1) dpUpdated
    dp = loopLCS 1 1 dpBase
  in
    getCount dp len1 len2