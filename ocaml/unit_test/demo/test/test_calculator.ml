open OUnit2
module Calculator = Demo.Calculator

let test_calculator = "Calculator Tests" >:::
  [
    "test_add" >:: (fun _ ->
      assert_equal 5 (Calculator.add 2 3);
    );

    "test_subtract" >:: (fun _ ->
      assert_equal 1 (Calculator.subtract 3 2);
    );
  ]

let () =
  run_test_tt_main test_calculator