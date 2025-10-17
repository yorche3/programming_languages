#include <check.h>
#include <stdlib.h>
#include "../include/words.h"

START_TEST(test_reverse_string) {
    char* reversed_string = reverse_string("hello");
    ck_assert_str_eq(reversed_string, "olleh");
    free(reversed_string);

    reversed_string = reverse_string("a");
    ck_assert_str_eq(reversed_string, "a");
    free(reversed_string);

    reversed_string = reverse_string("");
    ck_assert_str_eq(reversed_string, "");
    free(reversed_string);
}

START_TEST(test_is_palindrome) {
    ck_assert(is_palindrome("race car") == true);
    ck_assert(is_palindrome("level") == true);
    ck_assert(is_palindrome("hallo") == false);
    ck_assert(is_palindrome("a") == true);
    ck_assert(is_palindrome("") == true);
}

START_TEST(test_is_substring) {
    ck_assert(kmp_search("test", "this is a test") == true);
    ck_assert(kmp_search("not", "this is a test") == false);
    ck_assert(kmp_search("", "any string") == true);
    ck_assert(kmp_search("abc", "abc") == true);
    ck_assert(kmp_search("abc", "ab") == false);
}

START_TEST(test_lcs) {
    ck_assert_int_eq(lcs("AGGTAB", "GXTXAYB"), 4);
    ck_assert_int_eq(lcs("ABC", "ABC"), 3);
    ck_assert_int_eq(lcs("ABC", "DEF"), 0);
    ck_assert_int_eq(lcs("", "ABC"), 0);
    ck_assert_int_eq(lcs("ABC", ""), 0);
}

Suite* words_suite(void) {
    Suite *s = suite_create("Words Test Suite");
    TCase *tc = tcase_create("Core");
    tcase_add_test(tc, test_reverse_string);
    tcase_add_test(tc, test_is_palindrome);
    tcase_add_test(tc, test_is_substring);
    tcase_add_test(tc, test_lcs);
    suite_add_tcase(s, tc);
    return s;
}