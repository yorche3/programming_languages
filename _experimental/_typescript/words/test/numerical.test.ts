import { fibonacci, factorial, gcd, lcm } from '../src/numerical';

describe ('Numerical Functions', () => {
  test('fibonacci', () => {
    expect(fibonacci(-3)).toBe(-1);
		expect(fibonacci(10)).toBe(55);
		expect(fibonacci(15)).toBe(610);
  });
	test('factorial', () => {
		expect(factorial(-3)).toBe(-1);
		expect(factorial(5)).toBe(120);
		expect(factorial(10)).toBe(3628800);
	});
	test('greatest common divisor', () => {
		expect(gcd(48, 18)).toBe(6);
		expect(gcd(100, 25)).toBe(25);
		expect(gcd(17, 13)).toBe(1);
	});
	test('least common multiple', () => {
		expect(lcm(4, 6)).toBe(12);
		expect(lcm(21, 6)).toBe(42);
		expect(lcm(2, 3)).toBe(6);
	});
});
