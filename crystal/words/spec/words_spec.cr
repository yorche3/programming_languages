require "spec"
require "../src/words.cr"

describe Words do
  it "Reverse String" do
    Words.reverse_string("hello").should eq "olleh"
    Words.reverse_string("a").should eq "a"
    Words.reverse_string("").should eq ""
  end

  it "Is Palindrome" do
    Words.is_palindrome("race car").should be_true
    Words.is_palindrome("level").should be_true
    Words.is_palindrome("hello").should be_false
    Words.is_palindrome("a").should be_true
    Words.is_palindrome("").should be_true
  end

  it "Is Substring" do
    Words.kmp_search("test", "this is a test").should eq true
    Words.kmp_search("not", "this is a test").should eq false
    Words.kmp_search("", "any string").should eq true
    Words.kmp_search("abc", "abc").should eq true
    Words.kmp_search("abc", "ab").should eq false
  end

  it "Longest Common Subsequence" do
    Words.lcs("AGGTAB", "GXTXAYB").should eq 4
    Words.lcs("ABC", "ABC").should eq 3
    Words.lcs("ABC", "DEF").should eq 0
    Words.lcs("", "ABC").should eq 0
    Words.lcs("ABC", "").should eq 0
  end
end