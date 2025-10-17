let fibonacci n =
  let rec fib_iter n acc2 acc1 =
    if n < 0 then -1
    else if n <= 0 then n
    else if n == 2 then acc1 + acc2
    else fib_iter (n - 1) acc1 (acc1 + acc2)
  in
  fib_iter n 0 1

let factorial n =
  let rec fact_iter n acc =
    if n < 0 then -1
    else if n <= 1 then acc
    else fact_iter (n - 1) (n * acc)
  in
  fact_iter n 1

let rec gcd a b =
  if b = 0 then a
  else gcd b (a mod b)

let lcm a b =
  (a / (gcd a b)) * b