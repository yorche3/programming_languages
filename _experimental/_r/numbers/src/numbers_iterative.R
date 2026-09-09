fibonacci <- function(n) {
  return(fibonacci_iter(n, 0, 1))
}

fibonacci_iter <- function(n, acc2, acc1) {
  if (n <= 0) {
    return(acc2)
  } else if (n <= 2) {
    return(acc1 + acc2)
  } else {
    return(fibonacci_iter(n - 1, acc1, acc1 + acc2))
  }
}

factorial <- function(n) {
  return(factorrial_iter(n, 1))
}

factorrial_iter <- function(n, acc) {
  if (n <= 1) {
    return(acc)
  } else {
    return(factorrial_iter(n - 1, n * acc))
  }
}

sum_numbers <- function(n) {
  return(sum_numbers_iter(n, 0))
}

sum_numbers_iter <- function(n, acc) {
  if (n <= 0) {
    return(acc)
  } else {
    return(sum_numbers_iter(n - 1, n + acc))
  }
}