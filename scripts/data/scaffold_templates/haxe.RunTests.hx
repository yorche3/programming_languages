import utest.UTest;
import test.@MODULE@Test;

class RunTests {
    static public function main():Void {
        UTest.run([new @MODULE@Test()]);
    }
}
