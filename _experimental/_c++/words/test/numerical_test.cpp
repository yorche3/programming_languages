#include <gtest/gtest.h>
#include "../include/numerical.h"

class NumericalTest : public ::testing::Test
{
protected:
    Numerical _numerical;
};

TEST_F(NumericalTest, Fibonacci)
{
    EXPECT_EQ(_numerical.fibonacci(-2), -1);
    EXPECT_EQ(_numerical.fibonacci(10), 55);
    EXPECT_EQ(_numerical.fibonacci(15), 610);
}

TEST_F(NumericalTest, Factorial)
{
    EXPECT_EQ(_numerical.factorial(-3), -1);
    EXPECT_EQ(_numerical.factorial(5), 120);
    EXPECT_EQ(_numerical.factorial(10), 3628800);
}

TEST_F(NumericalTest, Greates_Common_Divisor)
{
    EXPECT_EQ(_numerical.gcd(48, 18), 6);
    EXPECT_EQ(_numerical.gcd(100, 25), 25);
    EXPECT_EQ(_numerical.gcd(17, 13), 1);
}

TEST_F(NumericalTest, Lowest_Common_Multiple)
{
    EXPECT_EQ(_numerical.lcm(4, 6), 12);
    EXPECT_EQ(_numerical.lcm(21, 6), 42);
    EXPECT_EQ(_numerical.lcm(7, 3), 21);
}