import kotlin.test.Test
import kotlin.test.assertEquals

class NumbersIterativeTest {

    private val nit = NumbersIterative()

    @Test
    fun testFibonacci() {
        assertEquals(5, nit.fibonacci(5))
    }

    @Test
    fun testFactorial() {
        assertEquals(120, nit.factorial(5))
    }

    @Test
    fun testSum_numbers() {
        assertEquals(15, nit.sumNumbers(5))
    }
}