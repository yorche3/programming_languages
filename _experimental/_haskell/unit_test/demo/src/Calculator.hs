module Calculator (addition, subtraction) where

addition :: Num a => a -> a -> a
addition x y = x + y

subtraction :: Num a => a -> a -> a
subtraction x y = x - y