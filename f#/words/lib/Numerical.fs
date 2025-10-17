namespace lib.Numerical

module Numerical =
  let fibonacci n =
    let rec fibonacciCalc n acc2 acc1 =
      match n with
        | n when n < 0 -> -1
        | n when n <= 1 -> n
        | n when n = 2 -> acc1 + acc2
        | _ -> fibonacciCalc (n - 1) acc1 (acc1 + acc2)
    fibonacciCalc n 0 1

  let factorial n = 
    let rec factorialCalc n acc =
      match n with
        | n when n < 0 -> -1
        | n when n <= 1 -> acc
        | _ -> factorialCalc (n - 1) (n * acc)
    factorialCalc n 1

  let rec gcd a b =
    if b = 0 then
      a
    else
      gcd b (a % b)

  let lcm a b =
    (a / (gcd a b)) * b