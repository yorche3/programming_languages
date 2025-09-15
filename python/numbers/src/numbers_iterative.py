def fibonacci_iter(n, acc2=0, acc1=1):
  if n <= 0:
    return acc2
  elif n <= 2:
    return acc1 + acc2
  else:
    return fibonacci_iter(n - 1, acc1, acc1 + acc2)
  
def fibonacci(n):
  return fibonacci_iter(n, 0, 1)

def factorial_iter(n, acc):
  if n <= 1:
    return acc
  else:
    return factorial_iter(n - 1, n * acc)
  
def factorial(n):
  return factorial_iter(n, 1)

def sum_numbers_iter(n, acc):
  if n <= 0:
    return acc
  else:
    return sum_numbers_iter(n - 1, n + acc)

def sum_numbers(n):
  return sum_numbers_iter(n, 0)