import { Calculator } from './calculator';

describe('Calculator', () => {
    const calc = new Calculator();

    test('Testing add...', () => {
        expect(calc.add(10, 15)).toBe(25);
    });

    test('Testing substract...', () => {
        expect(calc.subtract(20, 5)).toBe(15);
    });
});