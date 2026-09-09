export function fibonacci(n: number): number {
  if (n <= 1) return n;
  return fibonacci(n - 1) + fibonacci(n - 2);
}

export function factorial(n: number): number {
  if (n <= 1) return 1;
  return n * factorial(n - 1);
}

export function sum_numbers(n: number): number {
  if (n === 0) return 0;
  return n + sum_numbers(n - 1);
}