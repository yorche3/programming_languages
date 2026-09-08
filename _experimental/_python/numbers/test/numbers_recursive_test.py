import unittest

import sys
import os
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from src import numbers_recursive

class TestFibonacci(unittest.TestCase):
  def test_fibonacci(self):
    self.assertEqual(numbers_recursive.fibonacci(5), 5)
  
  def test_factorial(self):
    self.assertEqual(numbers_recursive.factorial(5), 120)

  def test_sum_numbers(self):
    self.assertEqual(numbers_recursive.sum_numbers(5), 15)

if __name__ == '__main__':
  unittest.main()