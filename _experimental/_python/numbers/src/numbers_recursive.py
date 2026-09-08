def fibonacci(n):
  if n <= 0:
    return 0
  elif n == 1:
    return 1
  else:
    return fibonacci(n - 1) + fibonacci(n - 2)

def factorial(n):
  if n <= 1:
    return 1
  else:
    return n * factorial(n - 1)

def sum_numbers(n):
  if n <= 0:
    return 0
  else:
    return n + sum_numbers(n - 1)