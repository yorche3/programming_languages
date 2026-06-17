-module(numbers_recursive).
-export([fibonacci/1, factorial/1, sum_numbers/1]).

fibonacci(N) when N =< 1 ->
    N;
fibonacci(N) ->
    fibonacci(N - 1) + fibonacci(N - 2).

factorial(N) when N =< 1 ->
    1;
factorial(N) ->
    N * factorial(N - 1).

sum_numbers(N) when N =< 0 ->
    0;
sum_numbers(N) ->
    N + sum_numbers(N - 1).