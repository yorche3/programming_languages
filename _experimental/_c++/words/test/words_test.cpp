#include <gtest/gtest.h>
#include "../include/words.h"

class WordsTest : public ::testing::Test
{
protected:
    Words _words;
};

TEST_F(WordsTest, Reverse_String)
{
    EXPECT_EQ(_words.reverse_string("hello"), "olleh");
    EXPECT_EQ(_words.reverse_string("a"), "a");
    EXPECT_EQ(_words.reverse_string(""), "");
}

TEST_F(WordsTest, Is_Palindrome)
{
    EXPECT_EQ(_words.is_palindrome("race car"), true);
    EXPECT_EQ(_words.is_palindrome("level"), true);
    EXPECT_EQ(_words.is_palindrome("hello"), false);
    EXPECT_EQ(_words.is_palindrome("a"), true);
    EXPECT_EQ(_words.is_palindrome(""), true);
}

TEST_F(WordsTest, Is_Substring)
{
    EXPECT_EQ(_words.kmp_search("test", "this is a test"), true);
    EXPECT_EQ(_words.kmp_search("not", "this is a test"), false);
    EXPECT_EQ(_words.kmp_search("", "any string"), true);
    EXPECT_EQ(_words.kmp_search("abc", "abc"), true);
    EXPECT_EQ(_words.kmp_search("abc", "ab"), false);
}

TEST_F(WordsTest, Longest_Common_Subsequence)
{
    EXPECT_EQ(_words.lcs("AGGTAB", "GXTXAYB"), 4);
    EXPECT_EQ(_words.lcs("ABC", "ABC"), 3);
    EXPECT_EQ(_words.lcs("ABC", "DEF"), 0);
    EXPECT_EQ(_words.lcs("", "ABC"), 0);
    EXPECT_EQ(_words.lcs("ABC", ""), 0);
}