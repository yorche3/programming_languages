package com.calculator;

import static org.junit.jupiter.api.Assertions.assertEquals;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

public class CalculatorTest {

    private Calculator calculator;

    @BeforeEach
    @SuppressWarnings("unused")
    void setUp() {
        System.out.println("Setting up the calculator for test...");
        this.calculator = new Calculator();
    }

    @Test
    void testAdd() {
        System.out.println("Testing addition...");
        int expected = 5;
        int actual = calculator.add(2, 3);
        assertEquals(expected, actual, "2 + 3 should equal 5");
    }

    @Test
    void testSubtract() {
        System.out.println("Testing subtraction...");
        int expected = 1;
        int actual = calculator.subtract(5, 4);
        assertEquals(expected, actual, "5 - 4 should equal 1");
    }
}
