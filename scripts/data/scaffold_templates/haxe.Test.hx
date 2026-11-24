package test;

import utest.Assert;
import utest.ITest;

class @MODULE@Test implements ITest {
    public function new() {}

    public function testNoTestsConfigured():Void {
        Assert.fail("No tests configured");
    }
}
