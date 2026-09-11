-module(numerical_test).
-include_lib("eunit/include/eunit.hrl").

iterative_fibonacci_test() ->
    ?assertEqual(-1, numerical:fibonacci(-3)),
    ?assertEqual(55, numerical:fibonacci(10)),
    ?assertEqual(610, numerical:fibonacci(15)).

iterative_factorial_test() ->
    ?assertEqual(-1, numerical:factorial(-3)),
    ?assertEqual(120, numerical:factorial(5)),
    ?assertEqual(3628800, numerical:factorial(10)).

greatest_common_divisor_test() ->
    ?assertEqual(6, numerical:gcd(48, 18)),
    ?assertEqual(25, numerical:gcd(100, 25)),
    ?assertEqual(1, numerical:gcd(17, 13)).

lowest_common_multiple_test() ->
    ?assertEqual(12, numerical:lcm(4, 6)),
    ?assertEqual(42, numerical:lcm(21, 6)),
    ?assertEqual(21, numerical:lcm(7, 3)).