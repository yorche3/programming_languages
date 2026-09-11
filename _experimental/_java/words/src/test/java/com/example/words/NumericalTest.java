package com.example.words;

import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.Test;

public class NumericalTest {
  @Test
  void testFibonacci() {
    assertEquals(-1, Numerical.fibonacci(-3));
    assertEquals(55, Numerical.fibonacci(10));
    assertEquals(610, Numerical.fibonacci(15));
  }

  @Test
  void testFactorial() {
    assertEquals(-1, Numerical.factorial(-3));
    assertEquals(120, Numerical.factorial(5));
    assertEquals(3628800, Numerical.factorial(10));
  }

  @Test
  void testGcd() {
    assertEquals(6, Numerical.gcd(48, 18));
    assertEquals(25, Numerical.gcd(100, 25));
    assertEquals(1, Numerical.gcd(17, 13));
  }

  @Test
  void testLcm() {
    assertEquals(12, Numerical.lcm(6, 4));
    assertEquals(42, Numerical.lcm(21, 6));
    assertEquals(21, Numerical.lcm(7, 3));
  }

}
