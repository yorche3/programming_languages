import unittest
import numerical

suite "Iterative Suite":
    test "fibonacci":
        assert fibonacci(-3) == -1
        assert fibonacci(10) == 55
        assert fibonacci(15) == 610
    
    test "factorial":
        assert factorial(-3) == -1
        assert factorial(5) == 120
        assert factorial(10) == 3628800

    test "greatest common divisor":
        assert gcd(48, 18) == 6
        assert gcd(100, 25) == 25
        assert gcd(17, 13) == 1

    test "lowest common multiple":
        assert lcm(6, 4) == 12
        assert lcm(21, 6) == 42
        assert lcm(7, 3) == 21