import haxe.unit.TestRunner;
import haxe.unit.TestCase;

import test.NumbersRecursiveTest;
import test.NumbersIterativeTest;

class RunTests extends TestRunner {
    static public function main() {
        var runner = new TestRunner();

        runner.add(new NumbersRecursiveTest());
        runner.add(new NumbersIterativeTest());
        
        runner.run();
    }
}