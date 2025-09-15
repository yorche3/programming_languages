let rec fibonacci n =
  if n <= 0 then 0
  else if n = 1 then 1
  else fibonacci (n - 1) + fibonacci (n - 2)

let rec factorial n =
  if n <= 1 then 1
  else n * factorial (n - 1)

let rec sum_numbers n =
  if n <= 0 then 0
  else n + sum_numbers (n - 1)