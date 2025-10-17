#ifndef WORDS_H
#define WORDS_H

#include <stdbool.h>

char* reverse_string(const char* str);
bool is_palindrome(const char* str);
bool kmp_search(const char* sub, const char* str);
int lcs(const char* str1, const char* str2);

#endif // WORDS_H