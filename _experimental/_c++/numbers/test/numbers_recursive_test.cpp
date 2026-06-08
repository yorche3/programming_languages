#include <gtest/gtest.h>
#include "../src/interfaces/numbers_recursive.h"

class RecursiveTest : public ::testing::Test
{
protected:
    NumbersRecursive numbers;
};

TEST_F(RecursiveTest, Fibonacci)
{
    EXPECT_EQ(numbers.fibonacci(5), 5);
}

TEST_F(RecursiveTest, Factorial)
{
    EXPECT_EQ(numbers.factorial(5), 120);
}

TEST_F(RecursiveTest, SumNumbers)
{
    EXPECT_EQ(numbers.sum_numbers(5), 15);
}