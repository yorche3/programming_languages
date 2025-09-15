using GLib;
using TestSuites;

public static int main(string[] args) {
    Test.init(ref args);
    NumbersRecursiveTest.addTests();
    NumbersIterativeTest.addTests();
    return Test.run();
}