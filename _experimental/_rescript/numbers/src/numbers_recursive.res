let rec fibonacci = n =>
  switch n {
  | n when n <= 1 => n
  | 2 => fibonacci(n - 1) + fibonacci(n - 2)
  | n => fibonacci(n - 1) + fibonacci(n - 2)
  }

let rec factorial = n =>
  switch n {
  | 1 => 1
  | n => n * factorial(n - 1)
  }

let rec sum_numbers = n =>
  switch n {
  | 0 => 0
  | n => n + sum_numbers(n - 1)
  }