#include <check.h>
#include "../include/numerical.h"

START_TEST(test_fibonacci) {
    ck_assert_int_eq(fibonacci(-3), -1);
    ck_assert_int_eq(fibonacci(10), 55);
    ck_assert_int_eq(fibonacci(15), 610);
}

START_TEST(test_factorial) {
    ck_assert_int_eq(factorial(-3), -1);
    ck_assert_int_eq(factorial(5), 120);
    ck_assert_int_eq(factorial(10), 3628800);
}

START_TEST(test_gcd) {
    ck_assert_int_eq(gcd(48, 18), 6);
    ck_assert_int_eq(gcd(100, 25), 25);
    ck_assert_int_eq(gcd(17, 13), 1);
}

START_TEST(test_lcm) {
    ck_assert_int_eq(lcm(4, 6), 12);
    ck_assert_int_eq(lcm(21, 6), 42);
    ck_assert_int_eq(lcm(7, 3), 21);
}

Suite* numerical_suite(void) {
    Suite *s = suite_create("Numerical Test Suite");
    TCase *tc = tcase_create("Core");
    tcase_add_test(tc, test_fibonacci);
    tcase_add_test(tc, test_factorial);
    tcase_add_test(tc, test_gcd);
    tcase_add_test(tc, test_lcm);
    suite_add_tcase(s, tc);
    return s;
}