open OUnit2
module Words = Liby.Words

let suite_words = "Words Suite" >:::
  [
    "reverse string" >:: (fun _ ->
      assert_equal "olleh" (Words.reverse_string "hello");
      assert_equal "a" (Words.reverse_string "a");
      assert_equal "" (Words.reverse_string "");
    );

    "is palindrome" >:: (fun _ ->
      assert_equal true (Words.is_palindrome "race car");
      assert_equal true (Words.is_palindrome "level");
      assert_equal false (Words.is_palindrome "hello");
      assert_equal true (Words.is_palindrome "a");
      assert_equal true (Words.is_palindrome "");
    );

    "is substring" >:: (fun _ ->
      assert_equal true (Words.kmp_search "test" "this is a test");
      assert_equal false (Words.kmp_search "not" "this is a test");
      assert_equal true (Words.kmp_search "" "any string");
      assert_equal true (Words.kmp_search "abc" "abc");
      assert_equal false (Words.kmp_search "abc" "ab");
    );

    "longest common subsequence" >:: (fun _ ->
      assert_equal 4 (Words.lcs "AGGTAB" "GXTXAYB");
      assert_equal 3 (Words.lcs "ABC" "ABC");
      assert_equal 0 (Words.lcs "ABC" "DEF");
      assert_equal 0 (Words.lcs "" "ABC");
      assert_equal 0 (Words.lcs "ABC" "");
    );
  ]

let () =
  run_test_tt_main suite_words