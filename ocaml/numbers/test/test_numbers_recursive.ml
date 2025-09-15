open OUnit2
module NumbersRecursive = Numbers.Numbers_recursive

let test_recursive = "Recursive Tests" >:::
  [
    "test_fibonacci" >:: (fun _ ->
      assert_equal 5 (NumbersRecursive.fibonacci 5);
    );

    "test_factorial" >:: (fun _ ->
      assert_equal 120 (NumbersRecursive.factorial 5);
    );

    "test_sum_numbers" >:: (fun _ ->
      assert_equal 15 (NumbersRecursive.sum_numbers 5);
    );
  ]

let () =
  run_test_tt_main test_recursive