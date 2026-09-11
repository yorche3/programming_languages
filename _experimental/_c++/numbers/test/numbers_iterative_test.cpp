#include <gtest/gtest.h>
#include "../src/interfaces/numbers_iterative.h"

class IterativeTest : public ::testing::Test
{
protected:
    NumbersIterative numbers;
};

TEST_F(IterativeTest, Fibonacci)
{
    EXPECT_EQ(numbers.fibonacci(5), 5);
}

TEST_F(IterativeTest, Factorial)
{
    EXPECT_EQ(numbers.factorial(5), 120);
}

TEST_F(IterativeTest, SumNumbers)
{
    EXPECT_EQ(numbers.sum_numbers(5), 15);
}