#include <check.h>
#include "../../src/interfaces/numbers_iterative.h"

START_TEST(test_iterative_fibonacci) {
    ck_assert_int_eq(fibonacci(5), 5);
}

START_TEST(test_iterative_factorial) {
    ck_assert_int_eq(factorial(5), 120);
}

START_TEST(test_iterative_sum) {
    ck_assert_int_eq((int)sum_numbers(5), 15);
}

Suite* iterative_numbers_suite(void) {
    Suite *s = suite_create("Iterative Numbers");
    TCase *tc = tcase_create("Core");
    tcase_add_test(tc, test_iterative_fibonacci);
    tcase_add_test(tc, test_iterative_factorial);
    tcase_add_test(tc, test_iterative_sum);
    suite_add_tcase(s, tc);
    return s;
}