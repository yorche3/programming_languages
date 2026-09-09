using GLib;
using NumbersIterativeNS;

namespace TestSuites {
  public class NumbersIterativeTest {
    public static void addTests() {
      Test.add_func("/NumbersIterative/fibonacci", () => {
        assert(5 == NumbersIterative.fibonacci(5));
      });

      Test.add_func("/NumbersIterative/factorial", () => {
        assert(120 == NumbersIterative.factorial(5));
      });

      Test.add_func("/NumbersIterative/sumNumbers", () => {
        assert(15 == NumbersIterative.sumNumbers(5));
      });
    }
  }
}