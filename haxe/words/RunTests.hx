import haxe.unit.TestRunner;
import haxe.unit.TestCase;

import test.NumericalTest;
import test.WordsTest;

class RunTests extends TestRunner {
    static public function main() {
        var runner = new TestRunner();

        runner.add(new NumericalTest());
        runner.add(new WordsTest());
        
        runner.run();
    }
}