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

fibonacci: procedure
  parse arg N
  return fibonacci_iter(N, 0, 1)

factorial: procedure
  parse arg N
  return factorial_iter(N, 1)

sum_numbers: procedure
  parse arg N
  return sum_numbers_iter(N, 0)

fibonacci_iter: procedure
  parse arg N, Acc2, Acc1
  if N <= 0 then return Acc2
  if N <= 2 then return Acc1 + Acc2
  return fibonacci_iter(N - 1, Acc1, Acc1 + Acc2)

factorial_iter: procedure
  parse arg N, Acc
  if N <= 1 then return Acc
  return factorial_iter(N - 1, N * Acc)

sum_numbers_iter: procedure
  parse arg N, Acc
  if N <= 0 then return Acc
  return sum_numbers_iter(N - 1, N + Acc)