use words::words::*;

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_reverse_string() {
        assert_eq!(reverse_string("hello"), "olleh");
        assert_eq!(reverse_string("a"), "a");
        assert_eq!(reverse_string(""), "");
    }

    #[test]
    fn test_is_palindrome() {
        assert_eq!(is_palindrome("race car"), true);
        assert_eq!(is_palindrome("level"), true);
        assert_eq!(is_palindrome("hello"), false);
        assert_eq!(is_palindrome("a"), true);
        assert_eq!(is_palindrome(""), true);
    }

    #[test]
    fn test_is_substring() {
        assert_eq!(kmp_search("test", "this is a test"), true);
        assert_eq!(kmp_search("not", "this is a test"), false);
        assert_eq!(kmp_search("", "any string"), true);
        assert_eq!(kmp_search("abc", "abc"), true);
        assert_eq!(kmp_search("abc", "ab"), false);
    }

    #[test]
    fn test_lcs() {
        assert_eq!(lcs("AGGTAB", "GXTXAYB"), 4);
        assert_eq!(lcs("ABC", "ABC"), 3);
        assert_eq!(lcs("ABC", "DEF"), 0);
        assert_eq!(lcs("", "ABC"), 0);
        assert_eq!(lcs("ABC", ""), 0);
    }
}