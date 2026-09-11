#!/usr/bin/perl
use strict;
use warnings;

require './lib/words.pl';

use Test::More tests => 18;

is(reverse_string("hello"), "olleh", "hello");
is(reverse_string("a"), "a", "a");
is(reverse_string(""), "", "");

is(is_palindrome("race car"), 1, "race car");
is(is_palindrome("level"), 1, "level");
is(is_palindrome("hello"), 0, "hello");
is(is_palindrome("a"), 1, "a");
is(is_palindrome(""), 1, "");

is(kmp_search("test", "this is a test"), 1, "is substring 1");
is(kmp_search("not", "this is a test"), 0, "is substring 2");
is(kmp_search("", "any string"), 1, "is substring 3");
is(kmp_search("abc", "abc"), 1, "is substring 4");
is(kmp_search("abc", "ab"), 0, "is substring 5");

is(lcs("AGGTAB", "GXTXAYB"), 4, "lcs 1");
is(lcs("ABC", "ABC"), 3, "lcs 2");
is(lcs("ABC", "DEF"), 0, "lcs 3");
is(lcs("", "ABC"), 0, "lcs 4");
is(lcs("ABC", ""), 0, "lcs 5");