import 'package:test/test.dart';
import '../lib/numbers_recursive.dart';

void main() {
  final numbers = NumbersRecursive();

  group('NumbersRecursive', () {
    test('fibonacci returns correct value for N=10', () {
      expect(numbers.fibonacci(10), equals(55));
    });

    test('factorial returns correct value for N=5', () {
      expect(numbers.factorial(5), equals(120));
    });

    test('sumNumbers returns correct sum for N=5', () {
      expect(numbers.sumNumbers(5), equals(15));
    });
  });
}