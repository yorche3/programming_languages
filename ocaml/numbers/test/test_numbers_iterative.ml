open OUnit2
module NumbersIterative = Numbers.Numbers_iterative

let test_recursive = "Iterative Tests" >:::
  [
    "test_fibonacci" >:: (fun _ ->
      assert_equal 5 (NumbersIterative.fibonacci 5);
    );

    "test_factorial" >:: (fun _ ->
      assert_equal 120 (NumbersIterative.factorial 5);
    );

    "test_sum_numbers" >:: (fun _ ->
      assert_equal 15 (NumbersIterative.sum_numbers 5);
    );
  ]

let () =
  run_test_tt_main test_recursive