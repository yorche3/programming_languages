module NumericalTest exposing (tests)

import Expect
import Test exposing (..)
import Numerical exposing (fibonacci, factorial, gcd, lcm)


tests : Test
tests =
    describe "Testing Solution1 and Solution2 implementations"
        [ -- Fibonacci tests
          describe "Fibonacci" 
            [ test "fibonacci -3" <| \_ -> Expect.equal (fibonacci 5) 5
            , test "fibonacci 10" <| \_ -> Expect.equal (fibonacci 10) 55
            , test "fibonacci 15" <| \_ -> Expect.equal (fibonacci 15) 610 ]
          
        , -- Factorial tests
          describe "Factorial"
            [ test "factorial 0" <| \_ -> Expect.equal (factorial -3) -1
            , test "factorial 5" <| \_ -> Expect.equal (factorial 5) 120
            , test "factorial 7" <| \_ -> Expect.equal (factorial 10) 3628800
            ]
          
        , -- GCD tests
          describe "Greatest Common Divisor"
            [ test "gcd of 48 and 18" <| \_ -> Expect.equal (gcd 48 18) 6
            , test "gcd of 100 and 25" <| \_ -> Expect.equal (gcd 100 25) 25
            , test "gcd of 17 and 13" <| \_ -> Expect.equal (gcd 17 13) 1
            ]
          
        , -- LCM tests
          describe "Lowest Common Multiple"
            [ test "lcm of 4 and 6" <| \_ -> Expect.equal (lcm 4 6) 12
            , test "lcm of 21 and 6" <| \_ -> Expect.equal (lcm 21 6) 42
            , test "lcm of 7 and 3" <| \_ -> Expect.equal (lcm 7 3) 21
            ]
        ]