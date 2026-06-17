module Numerical exposing (fibonacci, factorial, gcd, lcm)

fibonacci : Int -> Int
fibonacci n =
    let
      loop : Int -> Int -> Int -> Int
      loop i acc2 acc1 = 
        if i < 0 then -1
        else if i < 2 then n
        else if i == 2 then acc1 + acc2
        else loop (i - 1) acc1 (acc1 + acc2)
    in
    loop n 0 1

factorial : Int -> Int
factorial n =
  let
    loop : Int -> Int -> Int
    loop i acc =
      if i < 0 then -1
      else if i <= 1 then acc
      else loop (i - 1) (i * acc)
  in
  loop n 1

gcd : Int -> Int -> Int
gcd a b =
    if b == 0 then
        a
    else
        gcd b (modBy b a)

lcm : Int -> Int -> Int
lcm a b = (a // (gcd a b)) * b