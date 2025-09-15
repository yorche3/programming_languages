parse arg N
return factorial_iter(N, 1)

factorial_iter: procedure
  parse arg N, Acc
  if N <= 1 then return Acc
  return factorial_iter(N - 1, N * Acc)