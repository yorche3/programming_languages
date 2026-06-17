module WordsTest exposing (tests)

import Expect
import Test exposing (..)
import Words exposing (reverseString, isPalindrome, kmpSearch, lcs)

tests : Test
tests =
    describe "Word String Functions"
        [ -- reverseString tests
          describe "reverseString"
            [ test "reverse 'hello'" <| \_ -> Expect.equal (reverseString "hello") "olleh"
            , test "reverse 'a'" <| \_ -> Expect.equal (reverseString "a") "a"
            , test "reverse ''" <| \_ -> Expect.equal (reverseString "") ""
            , test "reverse 'abcde'" <| \_ -> Expect.equal (reverseString "abcde") "edcba"
            ]
          
        , -- isPalindrome tests
          describe "isPalindrome"
            [ test "race car" <| \_ -> Expect.equal (isPalindrome "race car") True
            , test "level" <| \_ -> Expect.equal (isPalindrome "level") True
            , test "hello" <| \_ -> Expect.equal (isPalindrome "hello") False
            , test "a" <| \_ -> Expect.equal (isPalindrome "a") True
            , test "_empty" <| \_ -> Expect.equal (isPalindrome "") True
            ]
          
        , -- isSubstring tests
          describe "isSubstring"
            [ test "test in 'this is a test'" <| \_ -> Expect.equal (kmpSearch "test" "this is a test") True
            , test "not in 'this is a test'" <| \_ -> Expect.equal (kmpSearch "not" "this is a test") False
            , test "empty substring" <| \_ -> Expect.equal (kmpSearch "" "any string") True
            , test "exact match" <| \_ -> Expect.equal (kmpSearch "abc" "abc") True
            , test "non-match" <| \_ -> Expect.equal (kmpSearch "abc" "ab") False
            ]
          
        , -- lcs tests
          describe "longest_common_subsequence"
            [ test "AGGTAB and GXTXAYB" <| \_ -> Expect.equal (lcs "AGGTAB" "GXTXAYB") 4
            , test "ABC and ABC" <| \_ -> Expect.equal (lcs "ABC" "ABC") 3
            , test "ABC and DEF" <| \_ -> Expect.equal (lcs "ABC" "DEF") 0
            , test "_empty and ABC" <| \_ -> Expect.equal (lcs "" "ABC") 0
            , test "ABC and _empty" <| \_ -> Expect.equal (lcs "ABC" "") 0
            ]
        ]