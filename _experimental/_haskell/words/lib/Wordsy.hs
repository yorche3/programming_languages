{-# LANGUAGE FlexibleContexts #-}
module Wordsy (reverseString, isPalindrome, kmpSearch, lcsy) where

import Data.Char (isSpace)
import Data.Array.Unboxed
import Data.Array.ST
import Control.Monad.ST
import Control.Monad (when, forM_)

reverseString :: String -> String
reverseString str = reverseStringHelper str []
  where
    reverseStringHelper :: String -> String -> String
    reverseStringHelper [] acc = acc
    reverseStringHelper (x:xs) acc = reverseStringHelper xs (x:acc)

isPalindrome :: String -> Bool
isPalindrome str =
  let cleanedStr = filter (not . isSpace) str
  in isPalindromeHelper cleanedStr 0 (length cleanedStr - 1)
  where
    isPalindromeHelper :: String -> Int -> Int -> Bool
    isPalindromeHelper strC i j 
      | i >= j = True
      | strC !! i /= strC !! j = False
      | otherwise = isPalindromeHelper strC (i + 1) (j - 1)

computeLPSArray :: String -> UArray Int Int
computeLPSArray patt
  | null patt = runSTUArray $ newArray (1, 0) 0
  | otherwise = runSTUArray $ do
      let lenPatt = length patt
      lps <- newArray (0, lenPatt - 1) 0 :: ST s (STUArray s Int Int)
      let loop i len = when (i < lenPatt) $ do
            if patt !! i == patt !! len
            then do
              writeArray lps i (len + 1)
              loop (i + 1) (len + 1)
            else do
              if len /= 0
              then do
                newLen <- readArray lps (len - 1)
                loop i newLen
              else loop (i + 1) 0
      loop 1 0
      return lps

kmpSearch :: String -> String -> Bool
kmpSearch sub str
  | null sub = True
  | null str = False
  | otherwise = search 0 0
    where
      lenSub = length sub
      lenStr = length str
      lps = computeLPSArray sub
      search :: Int -> Int -> Bool
      search i j
        | lenSub > lenStr = False
        | j == lenSub = True
        | i == lenStr = False
        | str !! i == sub !! j = search (i + 1) (j + 1)
        | j > 0 = search i (lps ! (j - 1))
        | otherwise = search (i + 1) j

lcsy :: String -> String -> Int
lcsy str1 str2 =
  let
    lenStr1 = length str1
    lenStr2 = length str2
  in runST $ do
    -- Create a 2D mutable array, initialized to 0
    dp <- newArray ((0, 0), (lenStr1, lenStr2)) 0 :: ST s (STUArray s (Int, Int) Int)
    forM_ [1..lenStr1] $ \i -> do
      forM_ [1..lenStr2] $ \j -> do
        if str1 !! (i - 1) == str2 !! (j - 1)
          then do
            val <- readArray dp (i - 1, j - 1)
            writeArray dp (i, j) (val + 1)
          else do
            val1 <- readArray dp (i - 1, j)
            val2 <- readArray dp (i, j - 1)
            writeArray dp (i, j) (max val1 val2)
    readArray dp (lenStr1, lenStr2)
