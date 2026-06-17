-module(numbers_iterative_test).
-include_lib("eunit/include/eunit.hrl").

iterative_fibonacci_test() ->
    ?assertEqual(55, numbers_iterative:fibonacci(10)).

iterative_factorial_test() ->
    ?assertEqual(120, numbers_iterative:factorial(5)).

iterative_sum_numbers_test() ->
    ?assertEqual(15, numbers_iterative:sum_numbers(5)).