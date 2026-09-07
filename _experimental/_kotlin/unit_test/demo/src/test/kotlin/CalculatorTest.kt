import kotlin.test.Test
import kotlin.test.assertEquals

class CalculatorTest {

    private val calculator = Calculator()

    @Test
    fun testAdd() {
        assertEquals(5, calculator.add(2, 3))
    }

    @Test
    fun testSubtract() {
        assertEquals(3, calculator.subtract(5, 2))
    }
}