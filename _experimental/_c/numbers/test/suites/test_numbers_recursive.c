#include <check.h>
#include "../../src/interfaces/numbers_recursive.h"

START_TEST(test_recursive_fibonacci) {
    ck_assert_int_eq(fibonacci(5), 5);
}

START_TEST(test_recursive_factorial) {
    ck_assert_int_eq(factorial(5), 120);
}

START_TEST(test_recursive_sum) {
    ck_assert_int_eq((int)sum_numbers(5), 15);
}

Suite* recursive_numbers_suite(void) {
    Suite *s = suite_create("Recursive Numbers");
    TCase *tc = tcase_create("Core");
    tcase_add_test(tc, test_recursive_fibonacci);
    tcase_add_test(tc, test_recursive_factorial);
    tcase_add_test(tc, test_recursive_sum);
    suite_add_tcase(s, tc);
    return s;
}