parse arg N
return factorial(N)

factorial: procedure
  parse arg N
  if N <= 1 then return 1
  return N * factorial(N - 1)