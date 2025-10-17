-module(words_test).
-include_lib("eunit/include/eunit.hrl").

reverse_string_test() ->
    ?assertEqual("olleh", words:reverse_string("hello")),
    ?assertEqual("a", words:reverse_string("a")),
    ?assertEqual("", words:reverse_string("")).

is_palindrome_test() ->
    ?assertEqual(true, words:is_palindrome("race car")),
    ?assertEqual(true, words:is_palindrome("level")),
    ?assertEqual(false, words:is_palindrome("hello")),
    ?assertEqual(true, words:is_palindrome("a")),
    ?assertEqual(true, words:is_palindrome("")).

is_substring_test() ->
    ?assertEqual(true, words:kmp_search("test", "this is a test")),
    ?assertEqual(false, words:kmp_search("not", "this is a test")),
    ?assertEqual(true, words:kmp_search("", "any string")),
    ?assertEqual(true, words:kmp_search("abc", "abc")),
    ?assertEqual(false, words:kmp_search("abc", "ab")).

largest_common_subsequence_test() ->
    ?assertEqual(4, words:lcs("AGGTAB", "GXTXAYB")),
    ?assertEqual(3, words:lcs("ABC", "ABC")),
    ?assertEqual(0, words:lcs("ABC", "DEF")),
    ?assertEqual(0, words:lcs("", "ABC")),
    ?assertEqual(0, words:lcs("ABC", "")).