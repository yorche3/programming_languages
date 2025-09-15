import unittest

def suite():
  test_loader = unittest.TestLoader()
  test_suite = unittest.TestSuite()

  test_suite.addTests(test_loader.loadTestsFromModule(__import__('numbers_recursive_test')))
  return test_suite

if __name__ == '__main__':
  runner = unittest.TextTestRunner()
  runner.run(suite())