parse arg N
return sum_numbers(N)

sum_numbers: procedure
  parse arg N
  if N <= 0 then return 0
  else return N + sum_numbers(N - 1)