call test_fibonacci
call test_factorial
call test_sum_numbers

exit

test_fibonacci:
  N = 5
  result = Fibonacci(N)
  if result = 5 then
    say "Fibonacci... [OK]"
  else
    say "Fibonacci... [FAILED]"
  return

test_factorial:
  N = 5
  result = factorial(N)
  if result = 120 then
    say "Factorial... [OK]"
  else
    say "Factorial... [FAILED]"
  return

test_sum_numbers:
  N = 5
  result = sum_numbers(N)
  if result = 15 then
    say "Sum_Numbers... [OK]"
  else
    say "Sum_Numbers... [FAILED]"
  return

Fibonacci: procedure
  parse arg N
  if N <= 0 then return 0
  if N <= 2 then return 1
  return fibonacci(N - 1) + fibonacci(N - 2)

Factorial: procedure
  parse arg N
  if N <= 1 then return 1
  return N * factorial(N - 1)

Sum_numbers: procedure
  parse arg N
  if N <= 0 then return 0
  else return N + sum_numbers(N - 1)