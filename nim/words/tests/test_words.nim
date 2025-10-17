import unittest
import words

suite "Words Suite":
    test "reverse string":
        assert reverseString("hello") == "olleh"
        assert reverseString("a") == "a"
        assert reverseString("") == ""
    
    test "is palindrome":
        assert isPalindrome("race car") == true
        assert isPalindrome("level") == true
        assert isPalindrome("hello") == false
        assert isPalindrome("a") == true
        assert isPalindrome("") == true
    
    test "is substring":
        assert kmpSearch("test", "this is a test") == true
        assert kmpSearch("not", "this is a test") == false
        assert kmpSearch("", "any string") == true
        assert kmpSearch("abc", "abc") == true
        assert kmpSearch("abc", "ab") == false

    test "longest common subsequence":
        assert lcs("AGGBTAB", "GXTXAYB") == 4
        assert lcs("ABC", "ABC") == 3
        assert lcs("ABC", "DEF") == 0
        assert lcs("", "ABC") == 0
        assert lcs("ABC", "") == 0