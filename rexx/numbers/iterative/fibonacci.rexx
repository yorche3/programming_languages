parse arg N
return fibonacci_iter(N, 0, 1)

fibonacci_iter: procedure
  parse arg N, Acc2, Acc1
  if N <= 0 then return Acc2
  if N <= 2 then return Acc1 + Acc2
  return fibonacci_iter(N - 1, Acc1, Acc1 + Acc2)