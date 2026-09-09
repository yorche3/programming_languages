let rec fibonacci_iter = (n, acc2, acc1) => {
    switch n {
    | 0 => 0
    | 1 => 1
    | 2 => acc1 + acc2
    | n => fibonacci_iter(n - 1, acc2, acc2 + acc1)
    }
}

let fibonacci = (n) => {
  fibonacci_iter(n, 0, 1)
}

let rec factorial_iter = (n, acc) =>
  switch n {
  | 1 => acc
  | n => factorial_iter(n - 1, n * acc)
  }

let factorial = (n) => {
  factorial_iter(n, n)
}

let rec sum_numbers_iter = (n, acc) =>
  switch n {
  | 0 => acc
  | n => sum_numbers_iter(n - 1, n + acc)
  }
  
let sum_numbers = (n) => {
  sum_numbers_iter(n, n)
}