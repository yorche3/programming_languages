import static org.junit.jupiter.api.Assertions.assertEquals;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

public class NumbersRecursiveTest {
    
    private NumbersRecursive numbersRecursive;

    @BeforeEach
    @SuppressWarnings("unused")
    void setUp() {
        System.out.println("Setting up NumbersRecursive for test...");
        this.numbersRecursive = new NumbersRecursive();
    }

    @Test
    void testFibonacci() {
        System.out.println("Testing Fibonacci...");
        int expected = 5;
        int actual = numbersRecursive.fibonacci(5);
        assertEquals(expected, actual, "Fibonacci of 5 should equal 5");
    }

    @Test
    void testFactorial() {
        System.out.println("Testing Factorial...");
        int expected = 120;
        int actual = numbersRecursive.factorial(5);
        assertEquals(expected, actual, "Factorial of 5 should equal 120");
    }

    @Test
    void testSumNumbers() {
        System.out.println("Testing Sum of Numbers...");
        int expected = 15;
        int actual = numbersRecursive.sumNumbers(5);
        assertEquals(expected, actual, "Sum of numbers up to 5 should equal 15");
    }
}
