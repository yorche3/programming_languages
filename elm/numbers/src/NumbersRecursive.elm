module NumbersRecursive exposing (fibonacci, factorial, sumNumbers)

fibonacci : Int -> Int
fibonacci n =
    if n <= 1 then
        n
    else
        fibonacci (n - 1) + fibonacci (n - 2)


factorial : Int -> Int
factorial n =
    if n <= 1 then
        1
    else
        n * factorial (n - 1)


sumNumbers : Int -> Int
sumNumbers n =
    if n <= 0 then
        0
    else
        n + sumNumbers (n - 1)