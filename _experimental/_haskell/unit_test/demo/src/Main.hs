module Main where

import Calculator (addition, subtraction)

main :: IO ()
main = do
  putStrLn "Calculator demo:"
  putStrLn $ "Add 3 and 4: " ++ show (addition 3 4)
  putStrLn $ "Subtract 10 and 7: " ++ show (subtraction 10 7)