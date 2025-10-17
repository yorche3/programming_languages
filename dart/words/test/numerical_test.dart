import 'package:words/numerical.dart';
import 'package:test/test.dart';

void main() {

  group('Numerical', () {
    test('Fibonacci function', () {
      expect(fibonacci(-3), equals(-1));
      expect(fibonacci(10), equals(55));
      expect(fibonacci(15), equals(610));
    });

    test('Factorial function', () {
      expect(factorial(-1), equals(-1));
      expect(factorial(5), equals(120));
      expect(factorial(10), equals(3628800));
    });

    test('Greatest Common Divisor function', () {
      expect(gcd(48, 18), equals(6));
      expect(gcd(100, 25), equals(25));
      expect(gcd(17, 13), equals(1));
    });

    test('Lowest Common Multiple', () {
      expect(lcm(4, 6), equals(12));
      expect(lcm(21, 6), equals(42));
      expect(lcm(7, 3), equals(21));
    });
  });
}