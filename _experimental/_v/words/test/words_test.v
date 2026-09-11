import words

fn test_reverse_string() {
    assert words.reverse_string("hello") == "olleh"
    assert words.reverse_string("a") == "a"
    assert words.reverse_string("") == ""
}

fn test_is_palindrome() {
    assert words.is_palindrome("race car") == true
    assert words.is_palindrome("level") == true
    assert words.is_palindrome("hello") == false
    assert words.is_palindrome("a") == true
    assert words.is_palindrome("") == true
}

fn test_is_substring() {
    assert words.kmp_search("test", "this is a test") == true
    assert words.kmp_search("not", "this is a test") == false
    assert words.kmp_search("", "any string") == true
    assert words.kmp_search("abc", "abc") == true
    assert words.kmp_search("abc", "ab") == false
}

fn test_lcs() {
    assert words.lcs("AGGTAB", "GXTXAYB") == 4
    assert words.lcs("ABC", "ABC") == 3
    assert words.lcs("ABC", "DEF") == 0
    assert words.lcs("", "ABC") == 0
    assert words.lcs("ABC", "") == 0
}