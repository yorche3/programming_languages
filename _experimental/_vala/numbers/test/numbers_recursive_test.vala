using GLib;
using NumbersRecursiveNS;

namespace TestSuites {
  public class NumbersRecursiveTest {
    public static void addTests() {
      Test.add_func("/NumbersRecursive/fibonacci", () => {
        assert(5 == NumbersRecursive.fibonacci(5));
      });

      Test.add_func("/NumbersRecursive/factorial", () => {
        assert(120 == NumbersRecursive.factorial(5));
      });

      Test.add_func("/NumbersRecursive/sumNumbers", () => {
        assert(15 == NumbersRecursive.sumNumbers(5));
      });
    }
  }
}