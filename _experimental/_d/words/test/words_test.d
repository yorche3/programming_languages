module d.words.test.words_test;

import std.stdio;

import words;

unittest {
    assert(Words.reverse_string("hello") == "olleh");
    assert(Words.reverse_string("a") == "a");
    assert(Words.reverse_string("") == "");
    writeln("[OK] Reverse String");
}

unittest {
    assert(Words.is_palindrome("race car") == true);
    assert(Words.is_palindrome("level") == true);
    assert(Words.is_palindrome("hello") == false);
    assert(Words.is_palindrome("a") == true);
    assert(Words.is_palindrome("") == true);
    writeln("[OK] Is Palindrome");
}

unittest {
    assert(Words.kmp_search("test", "this is a test") == true);
    assert(Words.kmp_search("not", "this is a test") == false);
    assert(Words.kmp_search("", "any string") == true);
    assert(Words.kmp_search("abc", "abc") == true);
    assert(Words.kmp_search("abc", "ab") == false);
    writeln("[OK] Is Substring");
}

unittest {
    assert(Words.lcs("AGGTAB", "GXTXAYB") == 4);
    assert(Words.lcs("ABC", "ABC") == 3);
    assert(Words.lcs("ABC", "DEF") == 0);
    assert(Words.lcs("", "ABC") == 0);
    assert(Words.lcs("ABC", "") == 0);
    writeln("[OK] Largest Common subsequence");
}