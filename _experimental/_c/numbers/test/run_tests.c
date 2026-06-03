#include <check.h>
#include <stdio.h>

extern Suite* recursive_numbers_suite(void);
extern Suite* iterative_numbers_suite(void);

int main() {
    int failed;
    SRunner *sr;

    // Run recursive suite
    sr = srunner_create(recursive_numbers_suite());
    srunner_run_all(sr, CK_NORMAL);
    failed = srunner_ntests_failed(sr);
    srunner_free(sr);

    // Run iterative suite
    sr = srunner_create(iterative_numbers_suite());
    srunner_run_all(sr, CK_NORMAL);
    failed += srunner_ntests_failed(sr);
    srunner_free(sr);

    return failed ? 1 : 0;
}