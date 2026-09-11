#include <check.h>
#include <stdio.h>

extern Suite* numerical_suite(void);
extern Suite* words_suite(void);

int main() {
    int failed;
    SRunner *sr;

    // Run numerical suite
    sr = srunner_create(numerical_suite());
    srunner_run_all(sr, CK_NORMAL);
    failed = srunner_ntests_failed(sr);
    srunner_free(sr);

    // Run words suite
    sr = srunner_create(words_suite());
    srunner_run_all(sr, CK_NORMAL);
    failed += srunner_ntests_failed(sr);
    srunner_free(sr);

    return failed ? 1 : 0;
}