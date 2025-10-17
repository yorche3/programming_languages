module NumbersRecursiveTest exposing (tests)

import Expect
import Test exposing (..)
import NumbersRecursive exposing (fibonacci, factorial, sumNumbers)


tests : Test
tests =
    describe "Testing Solution1 and Solution2 implementations"
        [ -- list of tests or describes
          describe "Fibonacci" 
            [ test "fib 5" <| \_ -> Expect.equal (fibonacci 5) 5 ]
          
        , describe "Factorial"
            [ test "fact 5" <| \_ -> Expect.equal (factorial 5) 120 ]
          
        , describe "Sum of First N"
            [ test "sum 5" <| \_ -> Expect.equal (sumNumbers 5) 15 ]
        ]