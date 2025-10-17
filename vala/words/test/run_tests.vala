using GLib;
using TestSuites;

public static int main(string[] args) {
    Test.init(ref args);
    NumericalTest.addTests();
    WordsTest.addTests();
    return Test.run();
}