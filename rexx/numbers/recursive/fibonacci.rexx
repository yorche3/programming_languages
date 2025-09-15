parse arg N
return fibonacci(N)

fibonacci: procedure
  parse arg N
  if N <= 0 then return 0
  if N <= 2 then return 1
  return fibonacci(N - 1) + fibonacci(N - 2)