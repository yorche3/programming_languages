export function fibonacci(n: number): number {
  return fibonacci_iter(n, 0, 1);
}

function fibonacci_iter(n: number, acc2: number, acc1: number): number {
  if (n <= 0) return acc2;
  if (n <= 2) return acc1 + acc2;
  return fibonacci_iter(n - 1, acc1, acc1 + acc2);
}

export function factorial(n: number): number {
  return factorial_iter(n, 1);
}

function factorial_iter(n: number, acc: number): number {
  if (n <= 1) return acc;
  return factorial_iter(n - 1, n * acc);
}

export function sum_numbers(n: number): number {
  return sum_numbers_iter(n, 0);
}

function sum_numbers_iter(n: number, acc: number): number {
  if (n <= 0) return acc;
  return sum_numbers_iter(n - 1, n + acc);
}