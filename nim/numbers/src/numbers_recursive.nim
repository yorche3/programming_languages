proc fibonacci*(n: int): int =
  if n <= 0: return 0
  elif n <= 2: return 1
  else: return fibonacci(n - 1) + fibonacci(n - 2)

proc factorial*(n: int): int =
  if n <= 1: return 1
  else: return n * factorial(n - 1)

proc sum_numbers*(n: int): int =
  if n <= 0: return 0
  else: return n + sum_numbers(n - 1)