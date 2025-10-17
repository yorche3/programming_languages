open OUnit2
module Numerical = Liby.Numerical

let suite_numerical = "Numerical Suite" >:::
  [
    "test_fibonacci" >:: (fun _ ->
      assert_equal (-1) (Numerical.fibonacci (-3));
      assert_equal 55 (Numerical.fibonacci 10);
      assert_equal 610 (Numerical.fibonacci 15);
    );

    "test_factorial" >:: (fun _ ->
      assert_equal (-1) (Numerical.factorial (-3));
      assert_equal 120 (Numerical.factorial 5);
      assert_equal 3628800 (Numerical.factorial 10);
    );

    "test_gcd" >:: (fun _ ->
      assert_equal 6 (Numerical.gcd 48 18);
      assert_equal 25 (Numerical.gcd 100 25);
      assert_equal 1 (Numerical.gcd 17 13);
    );

    "test_lcm" >:: (fun _ ->
      assert_equal 12 (Numerical.lcm 4 6);
      assert_equal 42 (Numerical.lcm 21 6);
      assert_equal 21 (Numerical.lcm 7 3);
    );
  ]

let () =
  run_test_tt_main suite_numerical