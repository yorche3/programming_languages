from basic_math import *
import unittest

class TestBasicMath(unittest.TestCase):

    def test_add(self):
        self.assertEqual(add(2,2), 4)

    def test_min(self):
        self.assertEqual(min(2,5),2)

    def test_max(self):
        self.assertEqual(max(8, 4), 8)

if __name__ == '__main__':
    unittest.main()
