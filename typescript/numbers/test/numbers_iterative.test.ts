import { fibonacci, factorial, sum_numbers } from '../src/numbers_iterative';

describe('Iterative Number Functions', () => {
  test('fibonacci(5) should be 5', () => {
    expect(fibonacci(5)).toBe(5);
  });
  test('factorial(5) should be 120', () => {
    expect(factorial(5)).toBe(120);
  });
  test('sum_numbers(5) should be 15', () => {
    expect(sum_numbers(5)).toBe(15);
  });
});