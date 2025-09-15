parse arg N
return sum_numbers_iter(N, 0)

sum_numbers_iter: procedure
  parse arg N, Acc
  if N <= 0 then return Acc
  return sum_numbers_iter(N - 1, N + Acc)