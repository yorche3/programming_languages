import org.junit.Test;
import static org.junit.Assert.assertEquals;

public class BasicMathTest{
    BasicMath bm = new BasicMath();

    @Test
    public void testAddition(){
	assertEquals(3,bm.addition(1,2));
    }

    @Test
    public void testMultiply(){
	assertEquals(3,bm.multiply(1,3));
    }
}
