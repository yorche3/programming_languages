let fibonacci n =
  let rec fib_iter n acc2 acc1 =
    if n <= 0 then acc2
    else if n <= 2 then acc1 + acc2
    else fib_iter (n - 1) acc1 (acc1 + acc2)
  in
  fib_iter n 0 1

let factorial n =
  let rec fact_iter n acc =
    if n <= 1 then acc
    else fact_iter (n - 1) (n * acc)
  in
  fact_iter n 1

let sum_numbers n =
  let rec sum_iter n acc =
    if n <= 0 then acc
    else sum_iter (n - 1) (n + acc)
  in
  sum_iter n 0