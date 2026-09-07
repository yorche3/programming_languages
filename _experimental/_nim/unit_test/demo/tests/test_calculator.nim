import unittest
import calculator

suite "Calculator Tests":
    test "add positive numbers":
        assert add(2, 3) == 5
        
    test "subtract positive numbers":
        assert subtract(5, 3) == 2