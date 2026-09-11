proc fibonacci_iter(n, acc2, acc1: int): int =
  if n <= 0: return acc2
  elif n <= 2: return acc1 + acc2
  else: return fibonacci_iter(n - 1, acc1, acc1 + acc2)

proc fibonacci*(n: int): int =
  return fibonacci_iter(n, 0, 1)

proc factorial_iter(n, acc: int): int =
  if n <= 1: return acc
  else: return factorial_iter(n - 1, n * acc)

proc factorial*(n: int): int =
  return factorial_iter(n, 1)

proc sum_numbers_iter(n, acc: int): int =
  if n <= 0: return acc
  else: return sum_numbers_iter(n - 1, n + acc)

proc sum_numbers*(n: int): int =
  return sum_numbers_iter(n, 0)