module NumbersIterative exposing (fibonacci, factorial, sumNumbers)

fibonacci : Int -> Int
fibonacci n =
    fibonacciIter n 0 1

fibonacciIter : Int -> Int -> Int -> Int
fibonacciIter n acc2 acc1 =
    if n <= 0 then
        acc2
    else
        if n <= 2 then
            acc1 + acc2
        else
            fibonacciIter (n - 1) acc1 (acc1 + acc2)


factorial : Int -> Int
factorial n =
    factorialIter n 1

factorialIter : Int -> Int -> Int
factorialIter n acc =
    if n <= 1 then
        acc
    else
        factorialIter (n - 1) (n * acc)


sumNumbers : Int -> Int
sumNumbers n =
    sumIter n 0

sumIter : Int -> Int -> Int
sumIter n acc =
    if n <= 0 then
        acc
    else
        sumIter (n - 1) (n + acc)