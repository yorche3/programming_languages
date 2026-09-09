const std = @import("std");
const words = @import("words");

test "reverse string" {
    try std.testing.expect(std.mem.eql(u8, words.reverse_string("hello"), "olleh"));
    try std.testing.expect(std.mem.eql(u8, words.reverse_string("a"), "a"));
    try std.testing.expect(std.mem.eql(u8, words.reverse_string(""), ""));
}

test "is palindrome" {
    try std.testing.expect(words.is_palindrome("race car") catch false);
    try std.testing.expect(words.is_palindrome("level") catch false);
    try std.testing.expect(!(try words.is_palindrome("hello")));
    try std.testing.expect(words.is_palindrome("a") catch false);
    try std.testing.expect(words.is_palindrome("") catch false);
}

test "is substring" {
    try std.testing.expect(words.kmp_search("test", "this is a test") catch false);
    try std.testing.expect(!(try words.kmp_search("not", "this is a test")));
    try std.testing.expect(words.kmp_search("", "any string") catch false);
    try std.testing.expect(words.kmp_search("abc", "abc") catch false);
    try std.testing.expect(!(try words.kmp_search("abc", "ab")));
}

test "longest common subsequence" {
    try std.testing.expect((try words.lcs("AGGTAB", "GXTXAYB")) == 4);
    try std.testing.expect((try words.lcs("ABC", "ABC")) == 3);
    try std.testing.expect((try words.lcs("ABC", "DEF")) == 0);
    try std.testing.expect((try words.lcs("", "ABC")) == 0);
    try std.testing.expect((try words.lcs("ABC", "")) == 0);
}
