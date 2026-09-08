import unittest

def numerical_suite():
  test_loader = unittest.TestLoader()
  test_suite = unittest.TestSuite()

  test_suite.addTests(test_loader.loadTestsFromModule(__import__('numerical_test')))
  return test_suite

def words_suite():
  test_loader = unittest.TestLoader()
  test_suite = unittest.TestSuite()
  
  test_suite.addTests(test_loader.loadTestsFromModule(__import__('words_test')))
  return test_suite

if __name__ == '__main__':
  runner = unittest.TextTestRunner()
  print("Running NumericalTests:")
  runner.run(numerical_suite())
  print("\nRunning WordsTests:")
  runner.run(words_suite())