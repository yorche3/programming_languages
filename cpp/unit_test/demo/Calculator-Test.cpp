#include <gtest/gtest.h>
#include "Calculator.h"

TEST(CalculatorTest, AddNumbers) {
    EXPECT_EQ(add(2, 3), 5);
}

TEST(CalculatorTest, SubtractNumbers) {
    EXPECT_EQ(subtract(5, 3), 2);
}

int main(int argc, char **argv) {
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}