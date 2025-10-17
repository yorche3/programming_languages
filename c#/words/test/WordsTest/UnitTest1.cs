namespace WordsTest;

using Words;

public class UnitTest1
{
    private readonly Class1 _words = new Class1();

    [Fact]
    public void TestReverseString()
    {
        Assert.Equal("olleh", _words.ReverseString("hello"));
        Assert.Equal("a", _words.ReverseString("a"));
        Assert.Equal("", _words.ReverseString(""));
    }

    [Fact]
    public void TestIsPalindrome()
    {
        Assert.True(_words.IsPalindrome("race car"));
        Assert.True(_words.IsPalindrome("level"));
        Assert.False(_words.IsPalindrome("hello"));
        Assert.True(_words.IsPalindrome("a"));
        Assert.True(_words.IsPalindrome(""));
    }

    [Fact]
    public void TestIsSubstring()
    {
        Assert.True(_words.IsSubstring("test", "this is a test"));
        Assert.False(_words.IsSubstring("not", "this is a test"));
        Assert.True(_words.IsSubstring("", "any string"));
        Assert.True(_words.IsSubstring("abc", "abc"));
        Assert.False(_words.IsSubstring("abc", "ab"));
    }

    [Fact]
    public void TestLCS()
    {
        Assert.Equal(4, _words.LCS("AGGTAB", "GXTXAYB"));
        Assert.Equal(3, _words.LCS("ABC", "ABC"));
        Assert.Equal(0, _words.LCS("ABC", "DEF"));
        Assert.Equal(0, _words.LCS("", "ABC"));
        Assert.Equal(0, _words.LCS("ABC", ""));
    }
}