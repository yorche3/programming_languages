def fibonacci(n):
  if n < 0:
    return -1
  elif n < 2:
    return n
  else:
    acc2 = 0
    acc1 = 1
    for _ in range(2, n):
      acc2, acc1 = acc1, acc1 + acc2
    return acc1 + acc2
  
def factorial(n):
  if n < 0:
    return -1
  else:
    acc = 1
    for i in range(2, n + 1):
      acc *= i
    return acc
  
def gcd(a, b):
  while b:
    a, b = b, a % b
  return a

def lcm(a, b):
  return (a // gcd(a, b)) * b