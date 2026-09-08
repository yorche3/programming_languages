import unittest

import sys
import os
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from src import numerical

class TestFibonacci(unittest.TestCase):
  def test_fibonacci(self):
    self.assertEqual(numerical.fibonacci(-3), -1)
    self.assertEqual(numerical.fibonacci(10), 55)
    self.assertEqual(numerical.fibonacci(15), 610)
  
  def test_factorial(self):
    self.assertEqual(numerical.factorial(-3), -1)
    self.assertEqual(numerical.factorial(5), 120)
    self.assertEqual(numerical.factorial(10), 3628800)

  def test_gcd(self):
    self.assertEqual(numerical.gcd(48, 18), 6)
    self.assertEqual(numerical.gcd(100, 25), 25)
    self.assertEqual(numerical.gcd(17, 13), 1)
  
  def test_lcm(self):
    self.assertEqual(numerical.lcm(6, 4), 12)
    self.assertEqual(numerical.lcm(21, 6), 42)
    self.assertEqual(numerical.lcm(7, 3), 21)