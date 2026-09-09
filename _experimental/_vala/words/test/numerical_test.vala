using GLib;
using NumericalNS;

namespace TestSuites {
  public class NumericalTest {
    public static void addTests() {
      Test.add_func("/Numerical/fibonacci", () => {
        assert(-1 == Numerical.fibonacci(-3));
        assert(55 == Numerical.fibonacci(10));
        assert(610 == Numerical.fibonacci(15));
      });

      Test.add_func("/Numerical/factorial", () => {
        assert(-1 == Numerical.factorial(-3));
        assert(120 == Numerical.factorial(5));
        assert(3628800 == Numerical.factorial(10));
      });

      Test.add_func("/Numerical/gcd", () => {
        assert(6 == Numerical.gcd(48, 18));
        assert(25 == Numerical.gcd(100, 25));
        assert(1 == Numerical.gcd(17, 13));
      });

      Test.add_func("/Numerical/lcm", () => {
        assert(12 == Numerical.lcm(4, 6));
        assert(42 == Numerical.lcm(21, 6));
        assert(21 == Numerical.lcm(7, 3));
      });
    }
  }
}