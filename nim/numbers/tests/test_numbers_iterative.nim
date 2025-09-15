import unittest
import numbers_iterative

suite "Iterative Tests":
    test "fibonacci of 5":
        assert fibonacci(5) == 5
    
    test "factorial of 5":
        assert factorial(5) == 120

    test "sum_numbers of 5":
        assert sum_numbers(5) == 15