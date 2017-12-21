from basic_math import *
import unittest

class TestBasicMath(unittest.TestCase):

    def test_hello(self):
        self.assertEqual(hello(), 'hola')

    def test_min(self):
        self.assertEqual(min(),2)

    def test_max(self):
        self.assertEqual(max(), 3.4)

if __name__ == '__main__':
    unittest.main()
