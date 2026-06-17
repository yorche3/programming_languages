-module(calculator_test).
-export([run_tests/0]).
-include_lib("eunit/include/eunit.hrl").

% Define test functions
add_test() ->
    [?_assertEqual(5, calculator:add(2, 3))].

subtract_test() ->
    [?_assertEqual(-1, calculator:subtract(2, 3))].

% Function to run all tests
run_tests() ->
    io:format("Running tests...~n"),
    eunit:test([calculator_test], [verbose]),
    io:format("All tests completed.~n").