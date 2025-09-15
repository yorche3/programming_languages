-module(numbers_recursive_test).
-include_lib("eunit/include/eunit.hrl").

recursive_fibonacci_test() ->
    ?assertEqual(55, numbers_recursive:fibonacci(10)).

recursive_factorial_test() ->
    ?assertEqual(120, numbers_recursive:factorial(5)).

recursive_sum_numbers_test() ->
    ?assertEqual(15, numbers_recursive:sum_numbers(5)).