let rec fibonacci = n =>
  if n < 0 {
    -1
  } else if n <= 1 {
    n
  } else {
    fibonacci(n - 1) + fibonacci(n - 2)
  }

let factorial = n => {
  let rec fact_iter = (n, acc) =>
    if n <= 1 {
      acc
    } else {
      fact_iter(n - 1, n * acc)
    }

  if n < 0 {
    -1
  } else {
    fact_iter(n, 1)
  }
}

let rec gcd = (a, b) =>
  if b == 0 {
    a
  } else {
    gcd(b, mod(a, b))
  }

let lcm = (a, b) =>
  if a == 0 || b == 0 {
    0
  } else {
    abs(a * b) / gcd(a, b)
  }
