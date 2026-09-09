using GLib;
using CalculatorNS;

public class CalculatorTest {
    static Calculator calc = new Calculator();

    public static void add_tests() {
        Test.add_func("/Calculator/add", () => {
            int a = 10;
            int b = 15;
            int result = calc.add(a, b);
            assert(25 == result);
        });

        Test.add_func("/Calculator/subtract", () => {
            int a = 20;
            int b = 5;
            int result = calc.subtract(a, b);
            assert(15 == result);
        });
    }
}

public static int main(string[] args) {
    Test.init(ref args);
    CalculatorTest calc_test = new CalculatorTest();
    calc_test.add_tests();
    return Test.run();
}