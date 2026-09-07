proc fibonacci*(n: int): int =
  if n < 0: return -1
  elif n < 2: return n
  else:
    var acc1 = 1
    var acc2 = 0
    for _ in 2..<n:
      (acc2, acc1) = (acc1, acc1 + acc2)
    return acc1 + acc2

proc factorial*(n: int): int =
  if n < 0: return -1
  else:
    var acc = 1
    for i in 2..n:
      acc *= i
    return acc

proc gcd*(a, b: int): int =
  var x = a
  var y = b
  while y != 0:
    (x, y) = (y, x mod y)
  return x

proc lcm*(a, b: int): int =
  return (a div gcd(a, b)) * b