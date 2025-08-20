#include "includes/unity.h"
#include "calculator.h"

void setUp(void)
{
    // This function can be used to set up any preconditions for the tests
}

void tearDown(void)
{
    // This function can be used to clean up after tests
}
// Test case for the add() function
void test_add(void)
{
    int expected = 5;
    int actual = add(2, 3);
    TEST_ASSERT_EQUAL_INT(5, actual);
}

void test_subtract(void)
{
    int expected = 1;
    int actual = subtract(3, 2);
    TEST_ASSERT_EQUAL_INT(expected, actual);
}

int main(void)
{
    UnityBegin("test_calculator.c");

    RUN_TEST(test_add);
    RUN_TEST(test_subtract);

    return UnityEnd();
}