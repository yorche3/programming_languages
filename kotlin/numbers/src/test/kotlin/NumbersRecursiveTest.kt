import kotlin.test.Test
import kotlin.test.assertEquals

class NumbersRecursiveTest {

    private val nr = NumbersRecursive()

    @Test
    fun testFibonacci() {
        assertEquals(5, nr.fibonacci(5))
    }

    @Test
    fun testFactorial() {
        assertEquals(120, nr.factorial(5))
    }

    @Test
    fun testSum_numbers() {
        assertEquals(15, nr.sumNumbers(5))
    }
}