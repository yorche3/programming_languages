:- use_module(library(plunit)).
:- consult('../src/words.pl').

:- begin_tests(words_suite).
test(reverse_string) :-
    reverse_string("hello", Result1),
    assertion(Result1 == "olleh"),
    reverse_string("a", Result2),
    assertion(Result2 == "a"),
    reverse_string("", Result3),
    assertion(Result3 == "").

test(is_palindrome) :-
    is_palindrome("race car", Result1),
    assertion(Result1 == 1),
    is_palindrome("level", Result2),
    assertion(Result2 == 1),
    is_palindrome("hello", Result3),
    assertion(Result3 == 0),
    is_palindrome("a", Result4),
    assertion(Result4 == 1),
    is_palindrome("", Result5),
    assertion(Result5 == 1).

test(kmp_search) :-
    kmp_search("test", "this is a test", Result1),
    assertion(Result1 == 1),
    kmp_search("not", "this is a test", Result2),
    assertion(Result2 == 0),
    kmp_search("", "any string", Result3),
    assertion(Result3 == 1),
    kmp_search("abc", "abc", Result4),
    assertion(Result4 == 1),
    kmp_search("abc", "ab", Result5),
    assertion(Result5 == 0).

test(lcs) :-
    lcs("AGGTAB", "GXTXAYB", Result1),
    assertion(Result1 == 4),
    lcs("ABC", "ABC", Result2),
    assertion(Result2 == 3),
    lcs("ABC", "DEF", Result3),
    assertion(Result3 == 0),
    lcs("", "ABC", Result4),
    assertion(Result4 == 0),
    lcs("ABC", "", Result5),
    assertion(Result5 == 0).

:- end_tests(words_suite).