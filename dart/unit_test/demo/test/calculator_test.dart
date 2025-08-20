import 'package:test/test.dart';
import '../lib/calculator.dart';

void main() {
  group('Calculator', () {
    final calculator = Calculator();

    test('adds two numbers', () {
      print('Testing add...');
      expect(calculator.add(2, 3), equals(5));
    });

    test('subtracts two numbers', () {
      print('Testing subtract...');
      expect(calculator.subtract(5, 3), equals(2));
    });
  });
}